<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Sultonov-557/dotfiles/main/.github/banner-dark.svg">
  <img alt="sultonov's dotfiles" src="https://raw.githubusercontent.com/Sultonov-557/dotfiles/main/.github/banner-light.svg">
</picture>

# dotfiles — Sultonov's Arch Linux setup

> Riced Gruvbox Dark. Managed with [chezmoi](https://chezmoi.io).

## Machines

| Hostname | Type   | GPU     | Monitors |
|----------|--------|---------|----------|
| vanguard | Desktop | NVIDIA  | DP-1 (2560x1440@165) + HDMI-A-1 (1920x1080@60) |
| archbook | Laptop | AMD     | eDP-1 (1920x1080@144) |
| server   | Server | -       | Headless |

## Stack

| Component | Choice | Fallback |
|-----------|--------|----------|
| **Shell** | fish | bash, zsh |
| **Prompt** | starship (minimal: dir + git + char) | - |
| **Terminal** | Ghostty | - |
| **WM** | Hyprland (Lua API) | - |
| **Shell tools** | zoxide, atuin, fzf, eza, bat, fd, ripgrep | - |
| **Multiplexer** | herdr | - |
| **Editor** | Neovim (lazy.nvim) | - |
| **Launcher** | rofi | - |
| **Notifications** | dunst | swaync (alternative) |
| **Session menu** | wlogout | - |
| **Browser** | Zen Browser | Firefox |
| **File manager** | yazi (CLI) | nvim-tree (editor) |
| **Media** | mpv, imv, zathura | - |
| **Shell/Bar** | Noctalia QuickShell | - |
| **DNS blocker** | AdGuardHome (systemd) | - |
| **Automount** | udiskie | - |
| **AUR helper** | paru | - |

## Quick install

```bash
# On a fresh Arch install:
sudo pacman -S chezmoi git
chezmoi init --apply https://github.com/Sultonov-557/dotfiles.git
```

This runs `install.sh` which:
1. Installs packages from `packages.txt`
2. Deploys all config files
3. Runs setup scripts (services, shell, GPG, wallpaper, etc.)

### Post-install checklist

- **Wallpaper** — `run_once_install-wallpaper.sh` downloads a default
- **Noctalia** — not auto-installed. Clone + run:
  ```bash
  git clone https://github.com/cloudmanic/noctalia ~/.config/noctalia
  qs -c noctalia-shell
  ```
- **AdGuardHome** — install + configure:
  ```bash
  sudo pacman -S adguardhome
  sudo systemctl enable --now adguardhome
  bash ~/.local/bin/setup-dns
  ```
- **Browser CSS** — `run_once_after_setup-firefox-chrome.sh` finds your Zen/Firefox profile and deploys the Gruvbox theme
- **Systemd user services** — enable the auto-apply timer and common services:
  ```bash
  systemctl --user enable --now chezmoi-apply.timer cliphist hyprpaper dunst
  ```

## Repository structure

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl     # Per-machine variables
├── install.sh              # Bootstrap script
├── packages.txt            # All packages for pacman + paru
├── scripts/                # Run-once setup scripts (run_*)
├── dot_bashrc              # Bash fallback
├── dot_profile             # Login shell env
├── dot_xprofile            # Display manager env
├── dot_inputrc             # Readline config
├── dot_face                # User avatar
├── dot_ssh/config.tmpl     # SSH config (templated)
├── dot_gnupg/gpg-agent.conf
├── dot_editorconfig        # Cross-editor consistency
├── dot_ripgreprc           # Ripgrep config
├── dot_gitconfig.tmpl      # Git config (templated)
├── dot_config/             # All ~/.config/ apps
│   ├── hypr/               # Hyprland (Lua + .conf)
│   ├── nvim/               # Neovim (lazy.nvim)
│   ├── fish/               # Fish shell
│   ├── ghostty/            # Terminal emulator
│   ├── yazi/               # File manager
│   ├── btop/               # Resource monitor
│   ├── fastfetch/          # System info
│   ├── dunst/              # Notifications
│   ├── rofi/               # Launcher menus
│   ├── wlogout/            # Session menu
│   ├── swaync/             # Notification center
│   ├── herdr/              # Terminal multiplexer
│   ├── qt5ct/ qt6ct/       # Qt theming
│   ├── gtk-3.0/ gtk-4.0/   # GTK theming
│   ├── systemd/user/       # User services + timers
│   ├── noсtalia/           # Noctalia shell config
│   ├── udiskie/            # Automount
│   ├── zen/                # Browser chrome CSS
│   └── ...                 # And more
├── dot_etc/                # System configs (deployed via run_once)
│   ├── paru.conf           # AUR helper config
│   ├── xdg/reflector/      # Mirror list management
│   └── sysctl.d/           # Kernel parameters
├── dot_local/bin/          # Custom scripts
│   ├── screenshot          # region/full/copy/active/picker
│   ├── recorder            # Screen recording (wl-screenrec)
│   ├── volume              # Volume OSD (wpctl)
│   ├── brightness          # Brightness OSD
│   ├── focus               # Deep focus mode
│   ├── perfmode            # Gaming performance toggle
│   ├── dnd                 # Do Not Disturb
│   ├── picker              # Color picker
│   ├── power-menu          # Rofi power menu
│   ├── shells              # QuickShell switcher
│   ├── flowstart           # Project workspace launcher
│   ├── block-distractions  # /etc/hosts site blocker
│   └── setup-dns           # AdGuardHome DNS config
└── dot_local/share/applications/  # Custom .desktop entries
```

## Keybindings

Managed in `dot_config/hypr/hyprland.lua`. The main modifier is `SUPER` (Windows key).

| Binding | Action |
|---------|--------|
| `SUPER + SPACE` | App launcher |
| `SUPER + SHIFT + SPACE` | Command launcher |
| `SUPER + Return` | Terminal |
| `SUPER + W` | Zen Browser |
| `SUPER + A` | Obsidian |
| `SUPER + E` | File manager |
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + V` | Toggle float |
| `SUPER + H/J/K/L` | Focus direction |
| `SUPER + SHIFT + H/J/K/L` | Move window |
| `SUPER + CTRL + H/J/K/L` | Resize |
| `SUPER + 1-0` | Switch workspace |
| `SUPER + SHIFT + 1-0` | Move window to workspace |
| `SUPER + S` | Scratchpad toggle |
| `SUPER + C` | Clipboard picker |
| `SUPER + D` | Control center |
| `Print` | Screenshot region |
| `SHIFT + Print` | Screenshot full |
| `F12` | Dropdown terminal |
| `SUPER + Escape` | Power menu |
| `SUPER + SHIFT + F12` | Focus mode |
| `XF86Audio*` / `XF86MonBrightness*` | Media/brightness keys |

## Neovim

Managed in `dot_config/nvim/`. Plugin manager: lazy.nvim.

| Plugin | Purpose |
|--------|---------|
| gruvbox-material | Colorscheme (Gruvbox Dark overrides) |
| nvim-lspconfig + mason | LSP: lua_ls, pyright, ts_ls, rust_analyzer, gopls, etc. |
| nvim-cmp + LuaSnip | Autocompletion + snippets |
| telescope.nvim | Fuzzy finder (files, grep, buffers, help) |
| nvim-treesitter | Syntax highlighting + parsing |
| gitsigns | Git signs in gutter |
| which-key | Keybinding popup |
| nvim-tree | File explorer |
| toggleterm | Floating/horizontal terminal |
| trouble | Diagnostics list viewer |
| todo-comments | Highlight TODO/FIXME/HACK |
| auto-session | Session save/restore |
| bufferline | Tab bar |
| lualine | Status line |
| alpha | Dashboard greeter |

## Neovim keymaps

All keybindings centralized in `lua/config/keymaps.lua`. See the file for the full list.

## themes / Noctalia

All apps use the **Gruvbox Dark** color scheme:
- **Theme**: Gruvbox-Dark (GTK) or hard-coded Gruvbox palette
- **Icons**: Papirus-Dark
- **Cursor**: Bibata-Modern-Classic
- **Font**: JetBrainsMono Nerd Font (11pt)
- **Shell/Bar**: Noctalia QuickShell with Gruvbox palette
- **Terminal**: Ghostty with 70% opacity + blur

## Dotfiles management

```bash
dot        # chezmoi
dota       # chezmoi add <file>
dotd       # chezmoi diff
dotu       # chezmoi update (pull + apply)
doto       # chezmoi apply
dotcd      # cd to chezmoi source dir
```

Auto-sync: `systemctl --user enable --now chezmoi-apply.timer` runs `chezmoi update --apply` every 6 hours.

## License

This is my personal configuration. Feel free to steal anything you like.
