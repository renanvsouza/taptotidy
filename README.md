# TapToTidy

You wrote a Slack message. It's... fine. Mostly. TapToTidy makes it better.

Highlight any text (Slack, Chrome, wherever), tap a shortcut, and a little popup hands you a
tidied-up version. Press Enter to copy it, Ctrl+V to swap it in. Your coworkers will never know.

> 🎶 **Proudly vibecoded.** This app was built by chatting with an AI until it worked.
> It's a toy that works on my machine and hopefully yours. Expect charm, not guarantees.

Requires Ubuntu/GNOME on Wayland and either [Claude Code](https://claude.com/claude-code)
(`claude`) or [opencode](https://opencode.ai) (`opencode`), installed and logged in.

**Privacy:** whatever you highlight is sent to the model provider you pick (Anthropic for `claude`,
the model's host for `opencode`; free opencode models may log or train on it). Don't use it on secrets.
The model runs with all tools disabled, so text you highlight can't make it read files or fetch URLs.

## Install

Download the latest package and install it:

```bash
curl -LO https://github.com/renanvsouza/taptotidy/releases/latest/download/taptotidy_all.deb
sudo apt install ./taptotidy_all.deb
taptotidy settings
```

There's no apt repository (for now), so updates are manual: fetch the new `.deb` and `apt install` it again.

Open **TapToTidy** from the app grid (or run `taptotidy settings`) and press **Save** to install the
default shortcuts:

| Shortcut  | Does                                  |
|-----------|---------------------------------------|
| Super+F10 | Rewrite for clarity                   |
| Super+F9  | Fix spelling and grammar only         |

In the popup: edit the suggestion if you like, **Enter** copies it and closes, **Esc** dismisses.

The package installs `/usr/bin/taptotidy`, the desktop entry and the icon, and pulls in `python3-gi`,
`gir1.2-gtk-4.0` and `wl-clipboard` via apt. You still need `claude` or `opencode` yourself.

### From source

If you'd rather build it yourself (no sudo needed to build):

```bash
git clone git@github.com:renanvsouza/taptotidy.git && cd taptotidy
./build-deb.sh                                  # -> dist/taptotidy_0.1.0_all.deb
sudo apt install ./dist/taptotidy_0.1.0_all.deb
```

Pass a version to override the default: `./build-deb.sh 1.2.0`.

Removing the package (`sudo apt remove taptotidy`) leaves the GNOME shortcuts it created behind,
because dpkg runs as root and can't touch your dconf. Run `taptotidy uninstall` first, or clear them
in Settings → Keyboard → Custom Shortcuts.

## Settings

Open **TapToTidy** from the app grid (or the gear icon in the popup) to pick the backend and model,
change the shortcuts, or edit the prompts. Stored in `~/.config/taptotidy/config.json`.

## Uninstall

```bash
taptotidy uninstall                     # drop the GNOME shortcuts first
sudo apt remove taptotidy
```

Your settings are kept in `~/.config/taptotidy` (delete it if you like).
