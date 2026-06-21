# Dotfiles TODO

## Status: Implementation complete

All items below are **done** — configs created in the chezmoi source directory.
Run `chezmoi apply` to deploy, then `hyprctl reload` to pick up changes.

---

## ✅ P0 — Core

- [x] **Bufferline** — `dot_config/nvim/lua/plugins/bufferline.lua`
  - `akinsho/bufferline.nvim`, Gruvbox-matched, LSP diagnostics, offsets

## ✅ P1 — Already installed (now configured)

- [x] **Hyprlock** — `dot_config/hypr/hyprlock.conf`
  - Clock, date, password input, Gruvbox via Noctalia colors
- [x] **Hypridle** — `dot_config/hypr/hypridle.conf`
  - 5min lock → 10min screen off → 15min suspend
- [x] **Dunst** — `dot_config/dunst/dunstrc`
  - Gruvbox theme, 3 urgency levels, notification rules for flow
- [x] **Clipboard** — cliphist + rofi picker (`SUPER + V`)
  - Clear clipboard (`SUPER + SHIFT + V`)
- [x] **Screenshots** — `dot_local/bin/screenshot`
  - `Print` = region+swappy, `SHIFT+Print` = full, `CTRL+Print` = copy, `CTRL+SHIFT+Print` = active monitor

## ✅ P2 — Chezmoi templates (cross-machine)

- [x] **`.gitconfig`** — `dot_gitconfig.tmpl`
  - Templates name/email, per-machine GPG signing, `includeIf` for work/personal dirs
- [x] **`.editorconfig`** — `dot_editorconfig`
  - Indent 2/4 per filetype, UTF-8, trim trailing whitespace
- [x] **Git global ignore** — `dot_config/git/ignore`
  - OS files, editor swaps, build dirs, Python/cache dirs
- [x] **Ripgrep** — `dot_ripgreprc`
  - `--smart-case`, `--hidden`, exclusions for .git/node_modules/.venv

## ✅ P3 — XDG / Platform

- [x] **MIME associations** — `dot_config/mimeapps.list`
  - firefox, nautilus, imv, mpv, zathura, file-roller
- [x] **User dirs** — `dot_config/user-dirs.dirs`
  - Screenshots, Projects, Pictures, etc.
- [x] **Fontconfig** — `dot_config/fontconfig/fonts.conf`
  - JetBrainsMono Nerd Font primary, Noto Color Emoji fallback
- [x] **Local scripts** — `dot_local/bin/`
  - `screenshot`, `picker`, `brightness`, `volume`, `power-menu`, `recorder`, `caffeine`, `dnd`, `perfmode`, `focus`, `flowstart`, `block-distractions`

## ✅ P4 — Normal desktop

- [x] **Power menu** — `dot_local/bin/power-menu` + rofi theme
  - `SUPER + Escape`: lock/logout/suspend/reboot/shutdown
- [x] **Color picker** — `dot_local/bin/picker`
  - `SUPER + SHIFT + C`: pick → hex to clipboard
- [x] **Screen recording** — `dot_local/bin/recorder`
  - `SUPER + SHIFT + R`: toggle wl-screenrec
- [x] **Dropdown terminal** — F12 → ghostty on special:dropdown, no decorations
- [x] **Zathura** — `dot_config/zathura/zathurarc` (Gruvbox, vi keys)
- [x] **imv** — `dot_config/imv/config` (Wayland, Gruvbox)
- [x] **MPV** — `dot_config/mpv/mpv.conf` (vaapi, wayland, Gruvbox OSD)
- [x] **Rofi** — `dot_config/rofi/config.rasi` + `power.rasi` (Gruvbox)
- [x] **Tmux** — `dot_config/tmux/tmux.conf` (vi keys, resurrect, continuum)
- [x] **Systemd env** — `dot_config/environment.d/wayland.conf`
- [x] **Auto-session** — nvim plugin (`rmagatti/auto-session`)
- [x] **Git per-directory** — `dot_config/git/config-work`, `dot_config/git/config-personal`
- [x] **Packages** — `packages.txt` updated (dunst, rofi, imv, zathura, mpv, tmux, direnv, hyprpicker, wl-screenrec, wlogout, udiskie, qalculate-gtk, file-roller, tumbler, poppler, helvum, pwvucontrol, rofi-emoji, obs-studio, ufw, cups, trash-cli, noto-fonts, base-devel)

## ✅ P5 — Flow state

- [x] **Focus mode** — `dot_local/bin/focus` + `SUPER + SHIFT + F12`
  - Mutes dunst, kills bar, disables idle, removes blur/rounding
- [x] **Do Not Disturb** — `dot_local/bin/dnd` + `SUPER + SHIFT + D`
- [x] **Caffeine** — `dot_local/bin/caffeine` + `SUPER + SHIFT + I`
  - Prevents idle/suspend
- [x] **Performance mode** — `dot_local/bin/perfmode` + `SUPER + SHIFT + P`
  - Toggles blur/shadow/animations on/off
- [x] **Project launcher** — `dot_local/bin/flowstart <dir>`
  - Opens terminal + editor on dedicated workspaces
- [x] **Distraction blocking** — `dot_local/bin/block-distractions`
  - Toggles /etc/hosts entries for social media
- [x] **Emoji picker** — `SUPER + .` → rofi-emoji
- [x] **Direnv** — hook in `config.fish`, `packages.txt`
- [x] **Session persistence** — tmux resurrect/continuum + nvim auto-session
- [x] **Git aliases** — comprehensive set in `dot_gitconfig.tmpl`
- [x] **OSD volume/brightness** — `dot_local/bin/volume`, `dot_local/bin/brightness`
  - Wrapped with notify-send, bound to multimedia keys

## ✅ P6 — Polish

- [x] Rofi config
- [x] MPV config
- [x] Systemd environment overrides
- [x] Ghostty dropdown profile

---

## Files added/modified (new files only)

```
~/.config/hypr/hyprlock.conf
~/.config/hypr/hypridle.conf
~/.config/dunst/dunstrc
~/.config/rofi/config.rasi
~/.config/rofi/power.rasi
~/.config/zathura/zathurarc
~/.config/imv/config
~/.config/mpv/mpv.conf
~/.config/tmux/tmux.conf
~/.config/ghostty/config.d/dropdown
~/.config/git/ignore
~/.config/git/config-work
~/.config/git/config-personal
~/.config/nvim/lua/plugins/auto-session.lua
~/.config/mimeapps.list
~/.config/user-dirs.dirs
~/.config/fontconfig/fonts.conf
~/.config/environment.d/wayland.conf
~/.local/bin/screenshot
~/.local/bin/picker
~/.local/bin/brightness
~/.local/bin/volume
~/.local/bin/power-menu
~/.local/bin/recorder
~/.local/bin/caffeine
~/.local/bin/dnd
~/.local/bin/perfmode
~/.local/bin/focus
~/.local/bin/flowstart
~/.local/bin/block-distractions
~/.gitconfig (templated)
~/.editorconfig
~/.ripgreprc
packages.txt (updated)
```

## New keybindings

| Key | Action |
|---|---|
| `SUPER + V` | Clipboard picker |
| `SUPER + ALT + X` | Clear clipboard |
| `SUPER + ALT + V` | Toggle window float |
| `SUPER + SHIFT + C` | Color picker |
| `SUPER + SHIFT + R` | Toggle screen recording |
| `SUPER + SHIFT + I` | Caffeine (idle inhibit) |
| `SUPER + SHIFT + D` | Do Not Disturb |
| `SUPER + SHIFT + P` | Performance mode |
| `SUPER + SHIFT + F12` | Focus mode |
| `SUPER + Escape` | Power menu |
| `SUPER + .` | Emoji picker |
| `F12` | Dropdown terminal |
| `Print` | Region screenshot |
| `SHIFT + Print` | Full screenshot |
| `CTRL + Print` | Copy region to clipboard |
| `CTRL + SHIFT + Print` | Copy active monitor |
