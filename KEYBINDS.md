# Keybinds

One convention, applied across every tool in this system. See
`docs/superpowers/specs/2026-07-28-keybind-integration-design.md` for the
full design rationale behind these choices.

## The constitution

1. **HJKL is the universal directional axis.** Any tool with directional
   navigation (window focus, pane focus, list movement, history search) uses
   `h`/`j`/`k`/`l` = left/down/up/right (or the 1-D equivalent: `j`/`k` =
   down/up, `n`/`N` = next/previous) unless the keys are structurally
   unavailable (a text-input context where typing conflicts).
2. **Modifiers layer by action-class on top of HJKL**, as far as each tool's
   keyspace allows: base modifier = primary action (usually focus), `+Shift`
   = secondary/mutating variant (usually move), `+Ctrl` = tertiary variant
   (usually resize).

**Tiebreaker:** if a tool's designated layer is already claimed by something
more fundamental, fall back to the nearest sane alternative and document it
as an intentional exception (see "Documented exceptions" below) rather than
force a collision or silently deviate.

## Hyprland (`dot_config/hypr/hyprland.lua`)

Modifier: `SUPER`.

### Focus / move / resize (HJKL, layered)

| Chord | Action |
|---|---|
| `SUPER+H/J/K/L` (also arrows) | Focus window left/down/up/right |
| `SUPER+Shift+H/J/K/L` (also arrows) | Move window left/down/up/right |
| `SUPER+Ctrl+H/J/K/L` | Resize window (−x/+y/−y/+x) |

### Workspaces

| Chord | Action |
|---|---|
| `SUPER+0-9` | Switch workspace |
| `SUPER+Shift+0-9` | Move window to workspace |
| `SUPER+Ctrl+0-9` | Move window to workspace (silent) |
| `SUPER+S` | Toggle special workspace ("magic") |
| `SUPER+Shift+S` | Move window to special workspace |
| `SUPER` + scroll | Scroll workspaces |

### Windows / layout

| Chord | Action |
|---|---|
| `SUPER+Q` | Close window |
| `SUPER+F` / `SUPER+Shift+F` | Fullscreen / fullscreen (mode 1) |
| `SUPER+V` / `SUPER+Shift+V` | Toggle float / pin |
| `SUPER+P` | Pseudotile |
| `SUPER+Alt+J` | Toggle split layout |
| `SUPER+T` / `SUPER+Shift+T` | Layout dwindle / master |
| `SUPER+O` | Cycle orientation |

### Apps / launchers

| Chord | Action |
|---|---|
| `SUPER+Space` | App launcher |
| `SUPER+Shift+Space` | Command launcher |
| `SUPER+Return` / `SUPER+Shift+Return` | Terminal / terminal in `~/` |
| `SUPER+W` | Zen browser |
| `SUPER+A` | Obsidian |
| `SUPER+G` | Steam |
| `SUPER+E` | File manager |
| `SUPER+C` | Clipboard picker |
| `SUPER+Alt+X` | Clear clipboard |

### Screenshots

| Chord | Action |
|---|---|
| `Print` | Screenshot region |
| `Shift+Print` | Screenshot full |
| `Ctrl+Print` | Screenshot copy |
| `Ctrl+Shift+Print` | Screenshot active |

### Session / power

| Chord | Action |
|---|---|
| `SUPER+Escape` | Session menu (Noctalia) — includes lock, suspend, reboot, shutdown |
| `SUPER+Ctrl+Escape` | Session menu fallback (wlogout — use if Noctalia/QuickShell isn't running) |
| `SUPER+Ctrl+Shift+L` | Exit Hyprland |

### Flow / utility

| Chord | Action |
|---|---|
| `SUPER+Shift+C` | Color picker |
| `SUPER+Shift+R` | Toggle screen recording |
| `SUPER+Shift+I` | Toggle caffeine (idle inhibit) |
| `SUPER+Shift+D` | Toggle Do Not Disturb |
| `SUPER+Shift+P` | Cycle power profile |
| `SUPER+Shift+F12` | Toggle focus mode |
| `F12` | Dropdown terminal (quake-style) |
| `SUPER+.` | Emoji picker |
| `SUPER+X` | Switch QuickShell config |
| `SUPER+D` | Toggle control center |
| `SUPER+Shift+O` | Turn off monitors |
| `XF86Audio*` / `XF86MonBrightness*` | Media/volume/brightness (via Noctalia IPC) |

Standalone CLI equivalents also exist in `dot_local/bin/` (`volume`,
`brightness`, `caffeine`, `dnd`, `perfmode`) for scripting or manual terminal
use — a second, independent invocation path, not a fallback for the keybind
path.

## Neovim (`dot_config/nvim/lua/config/keymaps.lua` + plugin files)

Leader: `<space>`.

### Split / pane navigation

| Chord | Action |
|---|---|
| `Ctrl+H/J/K/L` | Move focus across Neovim splits *and* herdr panes (`herdr_nav.lua`) |
| `Ctrl+Left/Right/Up/Down` | Resize the current split — documented exception, see below |

### Core

| Chord | Action |
|---|---|
| `jk` / `kj` (insert) | Escape |
| `Ctrl+S` | Save |
| `<leader>q` / `<leader>Q` | Save & quit / force quit |
| `<leader>h` | Clear search highlight |
| `n` / `N` / `*` / `#` | Search navigation, centered |

### LSP

| Chord | Action |
|---|---|
| `gd` / `gD` / `gi` / `gr` | Definition / declaration / implementation / references |
| `gR` | LSP references (Trouble) |
| `K` | Hover docs |
| `<leader>k` | Signature help |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>d` | Line diagnostics |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>F` | Format buffer |

### Git (gitsigns)

| Chord | Action |
|---|---|
| `<leader>gb` | Blame line |
| `<leader>gp` | Preview hunk |
| `<leader>gd` / `<leader>gD` | Diff / diff (index) |
| `<leader>gr` / `<leader>gR` | Reset hunk / reset buffer |
| `<leader>gu` | Undo stage hunk |
| `<leader>gg` | LazyGit |

### Telescope — `f` group

| Chord | Action |
|---|---|
| `<leader>ff` / `<leader><space>` | Find files |
| `<leader>fg` / `<leader>/` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fk` | Keymaps |
| `<leader>fq` | Quickfix |
| `<leader>fs` | Treesitter symbols |
| `<leader>fd` | Diagnostics |
| `<leader>f.` | Resume last picker |

Inside a picker: `Ctrl+J`/`Ctrl+K` move the selection, `Ctrl+C` closes. Raw
`hjkl` isn't bound — the prompt line is a text filter, typing `h`/`l` must
insert those characters, not navigate.

### Trouble — `x` group

| Chord | Action |
|---|---|
| `<leader>xx` | Toggle |
| `<leader>xw` / `<leader>xd` | Workspace / document diagnostics |
| `<leader>xq` | Quickfix |

### Todo / Terminal — `t` group

| Chord | Action |
|---|---|
| `<leader>tt` | Toggle terminal |
| `Ctrl+\` | Floating terminal |
| `<leader>to` | Todo (Trouble) |
| `<leader>tT` | Todo (Telescope) |
| `<leader>tn` / `<leader>tp` | Next / prev todo |

### Session — `w` group

| Chord | Action |
|---|---|
| `<leader>wr` / `<leader>ws` | Restore / save session |
| `<leader>wd` / `<leader>wl` | Delete / search session |

### File tree

| Chord | Action |
|---|---|
| `<leader>e` / `<leader>E` | Toggle / focus file tree |

## herdr (`dot_config/herdr/config.toml`)

Prefix: `Ctrl+g`.

### Direct (no prefix — frictionless)

| Chord | Action |
|---|---|
| `Ctrl+Shift+H` / `Ctrl+Shift+L` | Prev / next tab |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+W` | Close tab |
| `Ctrl+Shift+R` | Rename tab |
| `Ctrl+H/J/K/L` | Cross-app pane nav (herdr ↔ Neovim splits) |
| `Ctrl+Alt+H/J/K/L` | Cross-app pane nav, alternate dispatch (herdr-navigator) |

### With prefix (`Ctrl+g`, then...)

| Chord | Action |
|---|---|
| `h/j/k/l` | Focus pane left/down/up/right |
| `Shift+h` / `Shift+l` | Prev / next workspace |
| `Shift+n` | New workspace |
| `Shift+d` | Close workspace |
| `w` | Workspace picker |
| `v` | Split vertical |
| `-` | Split horizontal |
| `x` | Close pane |
| `z` | Zoom pane |
| `r` | Resize mode — documented exception, see below |
| `b` | Toggle sidebar |
| `?` | Help |
| `s` | Settings |
| `q` | Detach |
| `Shift+r` | Reload config |
| `Up` / `Down` | herdr-plus: projects / quick actions |

## Yazi (`dot_config/yazi/keymap.toml`)

| Chord | Action |
|---|---|
| `h` / `l` | Leave dir / enter dir |
| `j` / `k` | Move down / up |
| `J` / `K` | Half page down / up |
| `H` / `L` (also `u` / `U`) | Back / forward in history |
| `n` / `N` | Next / prev search match |
| `y`, `d` | Yank / remove selected |
| `p` / `P` | Paste / paste as symlink |
| `v` / `V` | Toggle selection / toggle all |
| `/` | Find |
| `f` | Filter |
| `s` | Sort |
| `.` | Toggle hidden |
| `t` | New tab |
| `1-5` | Switch to tab 1-5 |
| `]` / `[` | Next / prev tab |
| `q` / `Q` | Close tab or quit / quit (no cd) |
| `~` | Go home |
| `o` | Open file |

## fish / atuin

- Fish runs in vi-mode (`fish_vi_key_bindings`) — the normal/insert mode
  indicator is shown in the starship prompt.
- Atuin's history-search popup (`Ctrl+R`) runs in `vim-insert` keymap mode to
  match — `hjkl`/`Esc` work inside the popup, not just in the shell itself.
- fzf keeps `Ctrl+T` (file search) and `Alt+C` (cd); atuin is sourced after
  fzf in `config.fish`, so it — not fzf — owns `Ctrl+R`.

## rofi

No custom keybind overrides — its compiled-in defaults already include
`Ctrl+j`/`Ctrl+k` for row navigation, matching Telescope's convention above.
Not customized further; see the design spec's non-goals.

## Documented exceptions

| Where | What | Why |
|---|---|---|
| herdr | Modal resize (`prefix+r`, then `hjkl`) instead of a held `+Ctrl+hjkl` chord | Better UX for repeated resizing in a terminal mux; `Ctrl+hjkl` is already claimed by pane navigation |
| Neovim | Split-resize on arrows, not `Ctrl+hjkl` | `Ctrl+hjkl` is already claimed by cross-boundary Neovim↔herdr pane navigation |
| rofi / Telescope | No raw `hjkl` navigation | Both are text-filter list widgets — typing `h`/`l` must insert those characters. `Ctrl+j`/`Ctrl+k` already covers row navigation in both |
| wlogout | Bound to `SUPER+Ctrl+Escape`, separate from the primary `SUPER+Escape` session menu | Kept as an explicit manual fallback for when Noctalia/QuickShell isn't running, rather than left unreachable |
| `dot_local/bin` scripts (`volume`, `brightness`, `caffeine`, `dnd`, `perfmode`) | Exist alongside noctalia-IPC-bound keybind equivalents | Independently useful as CLI tools (e.g. scriptable from `flowstart`) — a second invocation path, not a fallback for the keybind path |
