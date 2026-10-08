# TapToTidy

Highlight text in any app (Slack, Chrome, …), press a shortcut, get an AI rewrite in a popup.
Press Enter to copy it, then Ctrl+V to replace the still-highlighted text.

Requires Ubuntu/GNOME on Wayland and either [Claude Code](https://claude.com/claude-code)
(`claude`) or [opencode](https://opencode.ai) (`opencode`), installed and logged in.

**Privacy:** whatever you highlight is sent to the model provider you pick (Anthropic for `claude`,
the model's host for `opencode`; free opencode models may log or train on it). Don't use it on secrets.
The model runs with all tools disabled, so text you highlight can't make it read files or fetch URLs.

## Install

```bash
git clone <this repo> && cd <repo> && ./install.sh
```

The installer tells you if any system packages are missing, then opens the settings window.
Press **Save** to set the default shortcuts:

| Shortcut  | Does                                  |
|-----------|---------------------------------------|
| Super+F10 | Rewrite for clarity                   |
| Super+F9  | Fix spelling and grammar only         |

In the popup: edit the suggestion if you like, **Enter** copies it and closes, **Esc** dismisses.

## Settings

Open **TapToTidy** from the app grid (or the gear icon in the popup) to pick the backend and model,
change the shortcuts, or edit the prompts. Stored in `~/.config/taptotidy/config.json`.

## Uninstall

```bash
./install.sh --uninstall
```
