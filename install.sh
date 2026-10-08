#!/usr/bin/env bash
# TapToTidy installer for Ubuntu/GNOME (per-user, no sudo).
# Usage: ./install.sh            install / update
#        ./install.sh --uninstall
set -euo pipefail
cd "$(dirname "$0")"

BIN="$HOME/.local/bin/taptotidy"
DESKTOP="$HOME/.local/share/applications/dev.taptotidy.desktop"
ICON="$HOME/.local/share/icons/hicolor/256x256/apps/dev.logo.svg"

if [ "${1:-}" = "--uninstall" ]; then
  if [ -x "$BIN" ]; then "$BIN" uninstall; fi  # removes the GNOME shortcuts
  rm -f "$BIN" "$DESKTOP" "$ICON"
  echo "TapToTidy removed. Your settings are kept in ~/.config/taptotidy (delete it if you like)."
  exit 0
fi

missing=()
python3 -c 'import gi; gi.require_version("Gtk", "4.0"); from gi.repository import Gtk' 2>/dev/null \
  || missing+=(python3-gi gir1.2-gtk-4.0)
command -v wl-copy >/dev/null || missing+=(wl-clipboard)
if [ ${#missing[@]} -gt 0 ]; then
  echo "Missing system packages. Install them, then re-run ./install.sh:"
  echo "  sudo apt install ${missing[*]}"
  exit 1
fi
if ! command -v claude >/dev/null && ! command -v opencode >/dev/null; then
  echo "Warning: neither 'claude' (Claude Code) nor 'opencode' found. TapToTidy needs one of them, logged in."
fi

install -Dm755 src/taptotidy.py "$BIN"
mkdir -p "$(dirname "$ICON")" "$(dirname "$DESKTOP")"
python3 -c 'import sys, gi; gi.require_version("GdkPixbuf", "2.0"); from gi.repository import GdkPixbuf
GdkPixbuf.Pixbuf.new_from_file_at_size(sys.argv[1], 256, 256).savev(sys.argv[2], "png", [], [])' \
  assets/logo.svg "$ICON"
# absolute Icon= path: a stale icon-theme.cache from another app can hide name-based lookups
cat > "$DESKTOP" <<EOF
[Desktop Entry]
Type=Application
Name=TapToTidy
Comment=Rewrite highlighted text with AI
Exec=$BIN settings
Icon=$ICON
Categories=Utility;
Keywords=rewrite;grammar;spelling;clarity;ai;
EOF

echo "Installed. Opening TapToTidy settings (also in your app grid as 'TapToTidy')..."
nohup "$BIN" settings >/dev/null 2>&1 &
