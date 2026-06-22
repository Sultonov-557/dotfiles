# Dotfiles TODO

## Status: Review complete — gaps identified

All dotfiles configs are **done**. The remaining work is **setup automation** — scripts and packages to make `bash install.sh` actually produce a working machine end-to-end.

---

## 🔴 P0 — Critical (setup breaks without these)

### Package gaps
- [ ] **Add `gh` to packages.txt** — gitconfig uses `gh auth git-credential`
- [ ] **Add `yazi` to packages.txt** — fish config has a `y()` wrapper for it
- [ ] **Add dev toolchains** to packages.txt:
  - `nodejs` + `npm` (fish PATH, Mason ts_ls, npm global packages)
  - `python` + `python-pip` (Mason pyright)
  - `rustup` (fish PATH, Mason rust-analyzer)
  - `go` (Mason gopls)
- [ ] **Add `gnome-keyring`** to packages.txt (secrets env vars for git/gpg)

### Missing run_once scripts
- [ ] **`run_once_install-aur-helper.sh`** — install paru/yay, since packages.txt has AUR items
- [ ] **`run_once_install-aur-packages.sh`** — install AUR packages from packages.txt
- [ ] **`run_once_install-tpm.sh`** — `git clone` TPM (tmux.conf line 88 depends on it)
- [ ] **`run_once_enable-services.sh`** — `systemctl enable --now` for: NetworkManager, bluetooth, cups, ufw
- [ ] **`run_once_set-default-shell.sh`** — `chsh -s $(which fish)`
- [ ] **`run_once_setup-xdg-dirs.sh`** — `xdg-user-dirs-update` + create `~/work/`, `~/Projects/`, etc.
- [ ] **`run_once_install-cursor-theme.sh`** — install Bibata-Modern-Classic cursor and Papirus-Dark icons (AUR)
- [ ] **`run_once_setup-gpg.sh`** — basic `~/.gnupg/gpg-agent.conf`, key generation prompt

### Noctalia / QuickShell
- [ ] **Document or script the Noctalia/QuickShell install** — autostart references:
  - `qs -c noctalia-shell`
  - `noctalia-launcher`
  - `noctalia-notes`
  - These are custom tools with no install path right now
- [ ] **Add wallpaper to repo** — hyprpaper.conf exists but no actual wallpaper file. Add a default or script to fetch one

---

## 🟡 P1 — Important (workflow incomplete without these)

### Shell fallbacks
- [ ] **Add `dot_bashrc`** — minimal bash config for recovery mode, SSH sessions, scripts
- [ ] **Add `dot_profile`** — login shell env vars (PATH, EDITOR, etc.) for display managers and SSH

### SSH & GPG
- [ ] **Add `dot_ssh/config.tmpl`** — chezmoi-templated SSH config with:
  - Host aliases for work servers
  - Key paths
  - KeepAlive settings
- [ ] **Add `dot_gnupg/gpg-agent.conf`** — pinentry program, cache TTL

### Environment
- [ ] **Add `dot_xprofile`** — legacy X11 fallback env vars (for GDM/SDDM on Wayland)
- [ ] **Add unrar/lz4/p7zip/unzip to packages.txt** — basic archive support

---

## 🔵 P2 — Nice to have

- [ ] **Add `swww` or `hyprwall` option** — wallpaper auto-fetch on first boot
- [ ] **Add `~/.local/share/applications/` custom .desktop entries** — AppImages, scripts
- [ ] **Add `dot_config/hypr/hyprland.conf` monitor template** — per-hostname monitor layout (eDP-1, DP-1, etc.)
- [ ] **Add `dot_config/bottom/btop.tmpl`** — btop config to match theme
- [ ] **Add `dot_config/kitty/kitty.conf`** — if ghostty ever needs a fallback
- [ ] **Add `dot_config/swaync/config.json`** — notification-center alternative for when dunst is muted
- [ ] **Prune duplicate packages** — both `pavucontrol` and `pwvucontrol` in packages.txt

---

## File manifest

```
install.sh                         # Bootstrap (exists)
packages.txt                       # Package list (needs updates ↑)
scripts/
  run_once_install-packages.sh.tmpl  # Exists — installs official pacman pkgs
  run_once_install-aur-helper.sh     # NEW — install paru/yay
  run_once_install-aur-packages.sh   # NEW — install AUR pkgs
  run_once_install-tpm.sh            # NEW — clone tmux plugins
  run_once_enable-services.sh        # NEW — enable system services
  run_once_set-default-shell.sh      # NEW — chsh to fish
  run_once_setup-xdg-dirs.sh         # NEW — create XDG dirs
  run_once_install-cursor-theme.sh   # NEW — Bibata + Papirus
  run_once_setup-gpg.sh              # NEW — gpg-agent config
dot_bashrc                           # NEW — bash fallback config
dot_profile                          # NEW — login shell env
dot_ssh/config.tmpl                  # NEW — SSH config template
dot_gnupg/gpg-agent.conf             # NEW — GPG agent config
```

---

## New keybindings (no changes planned)

Current keybinds are complete — no new bindings needed unless a new tool is added.
