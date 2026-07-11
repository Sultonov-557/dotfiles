# Dotfiles TODO

## Status: Most planned improvements completed ✓

All dotfiles configs are **done** and setup automation has been filled in.
This file tracks remaining nice-to-haves and future ideas.

---

## 🟢 Recently completed

- [x] **Tmux dead leaf cleaned** — aliases removed, tpm script deprecated
- [x] **paru over yay** — all package aliases now use paru (matches aur-helper)
- [x] **macOS leftover** — macos-titlebar-style removed from ghostty config
- [x] **Package dedup** — pwvucontrol removed (pavucontrol kept)
- [x] **bat theme** — BAT_THEME=Gruvbox-dark in all shells + xprofile
- [x] **dot_xprofile** — created for login-manager environment
- [x] **Per-host monitor layouts** — hyprland.lua now detects hostname
- [x] **Default wallpaper script** — run_once_after downloads placeholder
- [x] **btop config** — Gruvbox-themed btop.conf + custom theme file
- [x] **wlogout config** — layout + style.css for session menu
- [x] **fastfetch config** — Gruvbox-themed config.jsonc
- [x] **~/.face avatar** — SVG placeholder deployed via chezmoi
- [x] **dot_inputrc** — readline config for bash/python REPLs
- [x] **Udiskie config** — YAML config for automount daemon
- [x] **Firefox/Zen userChrome.css** — Gruvbox browser theme + deploy script
- [x] **Systemd user services** — cliphist, hyprpaper, dunst, polkit-gnome
- [x] **Enhanced .chezmoi.toml.tmpl** — per-machine booleans (is_laptop, has_nvidia, etc.)
- [x] **Post-install checklist** — added to install.sh
- [x] **Yazi config** — full Gruvbox config (yazi.toml, keymap.toml, theme.toml, init.lua)
- [x] **DNS setup script** — setup-dns to route systemd-resolved through AdGuardHome
- [x] **GTK bookmarks** — expanded with Projects, work, chezmoi dirs
- [x] **chezmoi auto-apply** — systemd timer runs `chezmoi update --apply` every 6h
- [x] **Neovim lazy-loading** — switched from eager to lazy-by-default with proper triggers

---

## 🟡 Still outstanding

- [ ] **Noctalia QuickShell install** — Noctalia is referenced in hyprland.lua but has no automated install. Install manually:
  ```
  git clone https://github.com/cloudmanic/noctalia ~/.config/noctalia
  qs -c noctalia-shell
  ```

- [ ] **Swaync config** — alternative notification center for when dunst is muted

- [ ] **Hyprland windowrulev2 config migration** — some rules still in .conf (Lua API gaps), check future Hyprland releases for full Lua parity

- [ ] **Prune duplicate env vars** — Wayland vars duplicated across dot_profile, dot_xprofile, and hyprland.lua. Consider consolidating to one source of truth

---

## 🔵 Future ideas

- [ ] **Nix home-manager flake** — experimental Nix-based config alongside chezmoi
- [ ] **Neovim LSP keymap consolidation** — move remaining LSP configs into keymaps.lua
- [ ] **Multi-monitor kanshi profile** — dynamic monitor profiles for dock/undock
- [ ] **Waybar config** — alternative status bar to Noctalia bar

---

## File manifest

```
install.sh                             # Bootstrap (updated with checklist)
packages.txt                           # Package list (deduped)
scripts/
  run_once_install-packages.sh.tmpl    # Official pacman packages
  run_once_install-aur-helper.sh       # Install paru
  run_once_install-aur-packages.sh     # AUR packages
  run_once_install-tpm.sh              # Deprecated (herdr replaces tmux)
  run_once_enable-services.sh          # Enable system services
  run_once_set-default-shell.sh        # chsh to fish
  run_once_setup-xdg-dirs.sh           # Create XDG dirs
  run_once_install-cursor-theme.sh     # Bibata + Papirus
  run_once_setup-gpg.sh               # GPG agent config
  run_once_after_install-wallpaper.sh.tmpl  # NEW — download wallpaper
  run_once_after_setup-firefox-chrome.sh    # NEW — deploy browser CSS
dot_bashrc                             # Bash fallback config
dot_profile                            # Login shell env (updated)
dot_xprofile                           # NEW — X11 login env
dot_inputrc                            # NEW — readline config
dot_face                               # NEW — user avatar SVG
dot_ssh/config.tmpl                    # SSH config template
dot_gnupg/gpg-agent.conf               # GPG agent config
dot_config/
  btop/btop.conf                       # NEW — Gruvbox resource monitor
  btop/themes/gruvbox_dark.theme       # NEW — btop theme
  fastfetch/config.jsonc               # NEW — fetch config
  wlogout/layout                       # NEW — session menu layout
  wlogout/style.css                    # NEW — session menu style
  systemd/user/*.service               # NEW — user service files
  udiskie/config.yml                   # NEW — automount config
  zen/browser/chrome/userChrome.css    # NEW — browser theme
```
