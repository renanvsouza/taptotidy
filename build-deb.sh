#!/usr/bin/env bash
# Build TapToTidy as a Debian package (system-wide install via apt/dpkg).
# Usage: ./build-deb.sh [version]      -> dist/taptotidy_<version>_all.deb
# Override the maintainer with: MAINTAINER="Name <mail>" ./build-deb.sh
set -euo pipefail
cd "$(dirname "$0")"

PKG=taptotidy
VERSION="${1:-0.1.0}"
MAINTAINER="${MAINTAINER:-Renan Souza <renanvicentim@gmail.com>}"
OUT=dist

if ! [[ "$VERSION" =~ ^[0-9] ]]; then
  echo "error: Debian versions must start with a digit (got '$VERSION')" >&2
  exit 1
fi
command -v dpkg-deb >/dev/null || { echo "error: dpkg-deb not found" >&2; exit 1; }

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# --- payload ---
install -Dm755 src/taptotidy.py "$STAGE/usr/bin/$PKG"

# The logo is a 1024px raster embedded in an SVG wrapper, so ship a PNG: same pixels, 27x smaller.
ICONS="$STAGE/usr/share/icons/hicolor"
mkdir -p "$ICONS/256x256/apps"
if python3 -c 'import sys, gi; gi.require_version("GdkPixbuf", "2.0"); from gi.repository import GdkPixbuf
GdkPixbuf.Pixbuf.new_from_file_at_size(sys.argv[1], 256, 256).savev(sys.argv[2], "png", [], [])' \
    assets/logo.svg "$ICONS/256x256/apps/dev.taptotidy.png" 2>/dev/null; then
  chmod 644 "$ICONS/256x256/apps/dev.taptotidy.png"
else
  echo "warning: could not rasterize the icon (python3-gi/gdk-pixbuf missing?); shipping the SVG" >&2
  install -Dm644 assets/logo.svg "$ICONS/scalable/apps/dev.taptotidy.svg"
fi

# .desktop basename must match the Gtk.Application id (dev.taptotidy) for GNOME to show the icon.
mkdir -p "$STAGE/usr/share/applications"
cat > "$STAGE/usr/share/applications/dev.taptotidy.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=TapToTidy
Comment=Rewrite highlighted text with AI
Exec=taptotidy settings
Icon=dev.taptotidy
Categories=Utility;
Keywords=rewrite;grammar;spelling;clarity;ai;
EOF
chmod 644 "$STAGE/usr/share/applications/dev.taptotidy.desktop"

# --- control metadata ---
mkdir -p "$STAGE/DEBIAN"
cat > "$STAGE/DEBIAN/control" <<EOF
Package: $PKG
Version: $VERSION
Architecture: all
Maintainer: $MAINTAINER
Installed-Size: $(du -sk "$STAGE" | cut -f1)
Depends: python3 (>= 3.10), python3-gi, gir1.2-gtk-4.0, wl-clipboard
Section: utils
Priority: optional
Description: rewrite highlighted text with an LLM from a popup
 TapToTidy reads the current primary selection, sends it to the local
 'claude' or 'opencode' CLI, and shows the rewritten text in a small
 popup. Enter copies the result back to the clipboard.
 .
 Requires a logged-in Claude Code or opencode installation and a
 GNOME/Wayland desktop. Settings live in ~/.config/taptotidy/.
EOF

# --- checksums and permissions ---
(cd "$STAGE" && find . -type f ! -path './DEBIAN/*' -print0 | sed -z 's|^\./||' | sort -z \
  | xargs -0 md5sum) > "$STAGE/DEBIAN/md5sums"
find "$STAGE" -type d -exec chmod 755 {} +

# --- build ---
mkdir -p "$OUT"
DEB="$OUT/${PKG}_${VERSION}_all.deb"
dpkg-deb --root-owner-group --build "$STAGE" "$DEB" >/dev/null

echo "Built $DEB"
dpkg-deb --info "$DEB" | sed -n '/Package:/p;/Version:/p;/Depends:/p'
echo
echo "Install with: sudo apt install ./$DEB"
echo "Note: removing the package leaves GNOME shortcuts it created; run 'taptotidy uninstall' first."
