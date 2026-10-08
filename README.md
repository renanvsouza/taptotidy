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
