# Keybind Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply one shared keybind convention ("the constitution": HJKL as the universal directional axis, modifiers layered by action-class) across Hyprland, Neovim, herdr, Yazi, fish/atuin, fix the three real Hyprland self-conflicts, and produce a canonical `KEYBINDS.md` reference.

**Architecture:** Config-only changes across 7 existing files plus one new reference doc. No build step, no automated test suite exists for this repo — verification is syntax/lint checks (which this environment can run) plus manual runtime checks (which only the target machine, with Hyprland/herdr/Neovim/Yazi/fish actually running, can do — each task states the exact manual command for that).

**Tech Stack:** Hyprland Lua API, TOML (herdr, Yazi, atuin), fish shell, Neovim Lua (which-key.nvim), Markdown.

## Global Constraints

- Spec: `docs/superpowers/specs/2026-07-28-keybind-integration-design.md` — every task below implements one row/section of that spec; do not deviate from the resolutions it states (e.g. delete-not-relocate for the lock binding, keep-not-remove for the `dot_local/bin` scripts).
- No automated test suite exists for this repo. "Test" in each task means: (a) a syntax/lint check this environment can actually run (`fish -n`, `python3 -c "import tomllib..."`, `grep` regression checks), run before AND after the edit to prove it's real, and (b) a manual verification command for the user to run on their actual machine afterward (`hyprctl reload`, launching Yazi, etc.) — these cannot be executed in this sandboxed environment, so they're documented, not run, here.
- Every edit uses exact `old_string`/`new_string` pairs matched against the current file content — do not paraphrase.
- Commit after each task with a `fix:`/`feat:`/`docs:` prefix matching this repo's existing commit style (see `git log --oneline`).

---

### Task 1: Fix the 3 Hyprland self-conflicts, add wlogout fallback bind, add constitution header comment

**Files:**
- Modify: `dot_config/hypr/hyprland.lua`

**Interfaces:** None (standalone config file, no cross-file dependency).

- [ ] **Step 1: Baseline conflict check (prove the bug exists before fixing it)**

Run:
```bash
grep -n 'mainMod .. " + J"\|mainMod .. " + SHIFT + S"\|CTRL + L"' dot_config/hypr/hyprland.lua
```
Expected output (3 pairs = 6 lines, each chord appearing twice):
```
235:hl.bind(mainMod .. " + J",             hl.dsp.layout("togglesplit"))
242:hl.bind(mainMod .. " + J",            hl.dsp.focus({ direction = "d" }))
223:hl.bind(mainMod .. " + SHIFT + S",       hl.dsp.exec_cmd("screenshot region"), { description = "Screenshot region" })
276:hl.bind(mainMod .. " + SHIFT + S",      hl.dsp.window.move({ workspace = "special:magic" }))
264:hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 60 0"))
300:hl.bind(mainMod .. " + CTRL + L",         hl.dsp.exec_cmd(noci .. " sessionMenu lock"), { description = "Lock screen" })
```
(Line numbers may shift slightly; what matters is each chord pattern matching twice.)

- [ ] **Step 2: Relocate togglesplit off `SUPER+J` to `SUPER+Alt+J`**

In `dot_config/hypr/hyprland.lua`:

Old:
```lua
hl.bind(mainMod .. " + J",             hl.dsp.layout("togglesplit"))
```
New:
```lua
hl.bind(mainMod .. " + ALT + J",       hl.dsp.layout("togglesplit"))
```

- [ ] **Step 3: Remove the screenshot duplicate on `SUPER+Shift+S`**

Old:
```lua
hl.bind("Print",                         hl.dsp.exec_cmd("screenshot region"))
hl.bind(mainMod .. " + SHIFT + S",       hl.dsp.exec_cmd("screenshot region"), { description = "Screenshot region" })
hl.bind("SHIFT + Print",               hl.dsp.exec_cmd("screenshot full"))
```
New:
```lua
hl.bind("Print",                         hl.dsp.exec_cmd("screenshot region"))
hl.bind("SHIFT + Print",               hl.dsp.exec_cmd("screenshot full"))
```
(`SUPER+Shift+S` now does exactly one thing — move window to special workspace, from the block in Step 5's neighboring binding at `mainMod .. " + SHIFT + S"` further down in the file, untouched.)

- [ ] **Step 4: Remove the redundant lock binding on `SUPER+Ctrl+L`**

Old:
```lua
-- --- Lock screen ---
hl.bind(mainMod .. " + CTRL + L",         hl.dsp.exec_cmd(noci .. " sessionMenu lock"), { description = "Lock screen" })
hl.bind(mainMod .. " + CTRL + SHIFT + L", hl.dsp.exec_cmd("hyprctl dispatch exit"))
```
New:
```lua
-- --- Exit Hyprland ---
-- Lock lives in the session menu (SUPER+Escape, option 1) — SUPER+CTRL+L is
-- reserved for window resize (+x), see the "Resize windows" block above.
hl.bind(mainMod .. " + CTRL + SHIFT + L", hl.dsp.exec_cmd("hyprctl dispatch exit"))
```

- [ ] **Step 5: Add the wlogout fallback keybind**

Old:
```lua
hl.bind(mainMod .. " + Escape",        hl.dsp.exec_cmd(noci .. " sessionMenu toggle"), { description = "Power menu" })
hl.bind(mainMod .. " + SHIFT + F12",   hl.dsp.exec_cmd("focus"), { description = "Toggle focus mode" })
```
New:
```lua
hl.bind(mainMod .. " + Escape",        hl.dsp.exec_cmd(noci .. " sessionMenu toggle"), { description = "Power menu" })
hl.bind(mainMod .. " + CTRL + Escape", hl.dsp.exec_cmd("wlogout"), { description = "Session menu (fallback, no Noctalia)" })
hl.bind(mainMod .. " + SHIFT + F12",   hl.dsp.exec_cmd("focus"), { description = "Toggle focus mode" })
```

- [ ] **Step 6: Add the constitution header comment**

Old:
```lua
-- =============================================================================
--     KEYBINDINGS
-- =============================================================================
local mainMod      = "SUPER"
```
New:
```lua
-- =============================================================================
--     KEYBINDINGS
-- =============================================================================
-- Constitution (full cross-tool reference: KEYBINDS.md):
--   1. HJKL is the universal directional axis.
--   2. Modifiers layer by action-class on top of HJKL: base = primary
--      (focus), +SHIFT = secondary (move), +CTRL = tertiary (resize).
--   New bindings should fit one of these layers, or +ALT (misc/layout),
--   before inventing a new pattern.
-- =============================================================================
local mainMod      = "SUPER"
```

- [ ] **Step 7: Verify no conflicts remain**

Run:
```bash
grep -c 'mainMod .. " + J"' dot_config/hypr/hyprland.lua        # expect 1 (focus down)
grep -c 'mainMod .. " + ALT + J"' dot_config/hypr/hyprland.lua  # expect 1 (togglesplit)
grep -c 'mainMod .. " + SHIFT + S"' dot_config/hypr/hyprland.lua # expect 1 (move to special)
grep -c 'CTRL + L"' dot_config/hypr/hyprland.lua                 # expect 1 (resize only)
grep -c 'CTRL + Escape"' dot_config/hypr/hyprland.lua            # expect 1 (wlogout)
```
Expected: `1` for every line (the literal substring `mainMod .. " + J"` does not occur within `mainMod .. " + ALT + J"`, so the two bindings don't double-count each other).

- [ ] **Step 8: Manual verification (run on the actual machine, not in this environment)**

```bash
hyprctl reload
```
Then confirm: `SUPER+J` only focuses the window below (no split toggle); `SUPER+Alt+J` toggles the split; `SUPER+Shift+S` only moves the window to the special workspace (screenshot still works via `Print`); `SUPER+Ctrl+L` only resizes; `SUPER+Escape` still opens the Noctalia session menu with lock as option 1; `SUPER+Ctrl+Escape` launches wlogout.

- [ ] **Step 9: Commit**

```bash
git add dot_config/hypr/hyprland.lua
git commit -m "$(cat <<'EOF'
fix: resolve 3 self-conflicting keybinds in hyprland.lua

SUPER+J, SUPER+Shift+S, and SUPER+Ctrl+L were each bound to two different
actions. Also adds a wlogout fallback bind (SUPER+Ctrl+Escape) so it's a
real fallback instead of unreachable config, and a header comment stating
the keybind convention this file follows.
EOF
)"
```

---

### Task 2: Fix herdr's tab-switch keys to match its own hjkl convention

**Files:**
- Modify: `dot_config/herdr/config.toml`

**Interfaces:** None.

- [ ] **Step 1: Baseline syntax check**

```bash
python3 -c "import tomllib; tomllib.load(open('dot_config/herdr/config.toml','rb')); print('toml ok')"
```
Expected: `toml ok`

- [ ] **Step 2: Swap arrow-key tab-switch for hjkl**

Old:
```toml
# Tab operations — direct bindings, no prefix needed (frictionless)
next_tab = "ctrl+shift+right"
previous_tab = "ctrl+shift+left"
```
New:
```toml
# Tab operations — direct bindings, no prefix needed (frictionless).
# hjkl (not arrows) to match every other directional binding in this file
# (pane focus, workspace switch) and the system-wide HJKL convention.
next_tab = "ctrl+shift+l"
previous_tab = "ctrl+shift+h"
```

- [ ] **Step 3: Verify syntax and no leftover arrow bindings**

```bash
python3 -c "import tomllib; tomllib.load(open('dot_config/herdr/config.toml','rb')); print('toml ok')"
grep -c "ctrl+shift+right\|ctrl+shift+left" dot_config/herdr/config.toml  # expect 0
grep -c "ctrl+shift+l\"\|ctrl+shift+h\"" dot_config/herdr/config.toml    # expect 2
```

- [ ] **Step 4: Manual verification (run on the actual machine)**

Reload herdr config (`prefix+Shift+r`, i.e. `Ctrl+g` then `Shift+R`), then confirm `Ctrl+Shift+L` switches to the next tab and `Ctrl+Shift+H` to the previous tab, and that pane focus (`prefix+hjkl`) and workspace switch (`prefix+Shift+h/l`) are unaffected.

- [ ] **Step 5: Commit**

```bash
git add dot_config/herdr/config.toml
git commit -m "$(cat <<'EOF'
fix: switch herdr tab-switching from arrows to hjkl

Tab-switch was the one direct binding in herdr still using arrow keys
while every other directional binding (pane focus, workspace switch)
uses hjkl. Ctrl+Shift+H/L replaces Ctrl+Shift+Left/Right.
EOF
)"
```

---

### Task 3: Fix Yazi's inverted j/k and n/N

**Files:**
- Modify: `dot_config/yazi/keymap.toml`

**Interfaces:** None.

- [ ] **Step 1: Baseline syntax check**

```bash
python3 -c "import tomllib; tomllib.load(open('dot_config/yazi/keymap.toml','rb')); print('toml ok')"
```

- [ ] **Step 2: Swap j/k so j=down, k=up (matching vim/system convention)**

Old:
```toml
  { on = "j", run = "arrow -1", desc = "Move down" },
  { on = "k", run = "arrow 1", desc = "Move up" },
```
New:
```toml
  { on = "j", run = "arrow 1", desc = "Move down" },
  { on = "k", run = "arrow -1", desc = "Move up" },
```

- [ ] **Step 3: Swap n/N so n=next, N=previous (matching vim and this repo's Neovim mapping)**

Old:
```toml
  { on = "n", run = "find_prev", desc = "Next match" },
  { on = "N", run = "find_next", desc = "Prev match" },
```
New:
```toml
  { on = "n", run = "find_next", desc = "Next match" },
  { on = "N", run = "find_prev", desc = "Prev match" },
```

- [ ] **Step 4: Verify syntax and the fix**

```bash
python3 -c "import tomllib; tomllib.load(open('dot_config/yazi/keymap.toml','rb')); print('toml ok')"
grep -A1 '"j", run' dot_config/yazi/keymap.toml   # expect j -> "arrow 1"
grep -A1 '"n", run' dot_config/yazi/keymap.toml   # expect n -> "find_next"
```

- [ ] **Step 5: Manual verification (run on the actual machine)**

Launch `yazi`, confirm `j` moves the cursor down the file list and `k` moves it up, and that `/searchterm` then `n` jumps to the next match while `N` jumps to the previous one.

- [ ] **Step 6: Commit**

```bash
git add dot_config/yazi/keymap.toml
git commit -m "$(cat <<'EOF'
fix: correct Yazi's inverted j/k and n/N bindings

j was bound to arrow -1 (up) and k to arrow 1 (down) — backwards from
vim/system convention despite this file's own header calling itself
"Vim-style". Same inversion existed for n/N search direction, also
backwards from Neovim's n/N mapping in this same dotfiles repo.
EOF
)"
```

---

### Task 4: Make atuin's history-search popup honor fish's vi-mode

**Files:**
- Modify: `dot_config/atuin/config.toml`

**Interfaces:** None.

- [ ] **Step 1: Baseline syntax check**

```bash
python3 -c "import tomllib; tomllib.load(open('dot_config/atuin/config.toml','rb')); print('toml ok')"
```

- [ ] **Step 2: Add `keymap_mode`**

Old:
```toml
enter_accept = true
filter_mode = "global"
search_mode = "fuzzy"
style = "compact"
inline_height = 8
show_preview = true
```
New:
```toml
enter_accept = true
filter_mode = "global"
search_mode = "fuzzy"
style = "compact"
inline_height = 8
show_preview = true

# Match fish's vi-mode (fish_vi_key_bindings in config.fish) so hjkl/Esc
# muscle memory carries into the history-search popup, not just the shell.
keymap_mode = "vim-insert"
```

- [ ] **Step 3: Verify**

```bash
python3 -c "import tomllib; d = tomllib.load(open('dot_config/atuin/config.toml','rb')); assert d['keymap_mode'] == 'vim-insert'; print('keymap_mode ok')"
```

- [ ] **Step 4: Manual verification (run on the actual machine)**

Open a new fish shell, press `Ctrl+R`, confirm the atuin popup opens; press `Esc` then `j`/`k` and confirm they move the selection instead of doing nothing/inserting text.

- [ ] **Step 5: Commit**

```bash
git add dot_config/atuin/config.toml
git commit -m "$(cat <<'EOF'
fix: set atuin keymap_mode to match fish's vi-mode

atuin's history-search popup silently defaulted to emacs keybindings
even though fish itself runs fish_vi_key_bindings — hjkl/Esc worked in
the shell prompt but not inside the popup.
EOF
)"
```

---

### Task 5: Fix the fish Ctrl+R shadow conflict between atuin and fzf

**Files:**
- Modify: `dot_config/fish/config.fish`

**Interfaces:** None.

- [ ] **Step 1: Baseline syntax check and confirm the current (wrong) order**

```bash
fish -n dot_config/fish/config.fish && echo "fish syntax OK"
grep -n "atuin init fish\|fzf --fish" dot_config/fish/config.fish
```
Expected: `atuin init fish` line number is LOWER than `fzf --fish` line number (atuin sourced first, so fzf's later Ctrl+R binding currently wins/shadows it).

- [ ] **Step 2: Remove the atuin block from its current location**

Old:
```fish
# ── Atuin (shell history) ────────────────────────────────────────────────────
if command -q atuin
  atuin init fish | source
end

# ── Direnv (per-project env vars) ─────────────────────────────────────────
```
New:
```fish
# ── Direnv (per-project env vars) ─────────────────────────────────────────
```

- [ ] **Step 3: Re-insert the atuin block after fzf, so atuin's Ctrl+R wins**

Old:
```fish
  fzf --fish | source
end

# ── Yazi (terminal file manager) ─────────────────────────────────────────────
```
New:
```fish
  fzf --fish | source
end

# ── Atuin (shell history) ────────────────────────────────────────────────────
# Sourced after fzf so atuin's Ctrl+R keybind wins (fzf keeps Ctrl+T/Alt+C,
# no conflict there).
if command -q atuin
  atuin init fish | source
end

# ── Yazi (terminal file manager) ─────────────────────────────────────────────
```

- [ ] **Step 4: Verify syntax and the new order**

```bash
fish -n dot_config/fish/config.fish && echo "fish syntax OK"
grep -n "atuin init fish\|fzf --fish" dot_config/fish/config.fish
```
Expected: `fzf --fish` line number is now LOWER than `atuin init fish` (fzf sourced first, atuin last — atuin wins Ctrl+R).

- [ ] **Step 5: Manual verification (run on the actual machine)**

Open a new fish shell, press `Ctrl+R`, confirm the atuin popup opens (not fzf's history search). Press `Ctrl+T`, confirm fzf's file search still opens.

- [ ] **Step 6: Commit**

```bash
git add dot_config/fish/config.fish
git commit -m "$(cat <<'EOF'
fix: make atuin win the Ctrl+R shadow conflict with fzf

Both atuin and fzf bind Ctrl+R in config.fish; fzf was sourced second
and silently won. atuin is the intended primary history tool (fuller
history sync), so it's now sourced last. fzf keeps Ctrl+T/Alt+C.
EOF
)"
```

---

### Task 6: Document Neovim's arrow-resize exception and disambiguate the which-key "t" group

**Files:**
- Modify: `dot_config/nvim/lua/config/keymaps.lua`
- Modify: `dot_config/nvim/lua/plugins/whichkey.lua`

**Interfaces:** None (comment/label-only changes, no behavior change).

- [ ] **Step 1: Baseline check — no lua interpreter is available in this environment, so use grep to confirm current state**

```bash
grep -n "Resize splits" dot_config/nvim/lua/config/keymaps.lua
grep -n 'group = "Todo"' dot_config/nvim/lua/plugins/whichkey.lua
```
Expected: one match each.

- [ ] **Step 2: Add the arrow-resize exception comment**

In `dot_config/nvim/lua/config/keymaps.lua`:

Old:
```lua
-- Resize splits
map("n", "<C-Left>", "<C-w><", { desc = "Decrease split width" })
```
New:
```lua
-- Resize splits
-- Arrows, not Ctrl+hjkl: Ctrl+hjkl is already claimed by herdr_nav.lua for
-- cross-boundary navigation between Neovim splits and herdr panes. This is
-- a documented exception to the HJKL convention (see KEYBINDS.md), not an
-- oversight.
map("n", "<C-Left>", "<C-w><", { desc = "Decrease split width" })
```

- [ ] **Step 3: Disambiguate the which-key "t" group label**

In `dot_config/nvim/lua/plugins/whichkey.lua`:

Old:
```lua
      { "<leader>t",  group = "Todo" },
```
New:
```lua
      { "<leader>t",  group = "Todo / Terminal" },
```
(toggleterm's `<leader>tt` and todo-comments' `<leader>to/tT/tn/tp` share the `t` prefix with distinct full keychains — no functional collision — but the group label previously implied only "Todo".)

- [ ] **Step 4: Verify both edits landed**

```bash
grep -n "documented exception" dot_config/nvim/lua/config/keymaps.lua
grep -n 'group = "Todo / Terminal"' dot_config/nvim/lua/plugins/whichkey.lua
```
Expected: one match each.

- [ ] **Step 5: Manual verification (run on the actual machine)**

Open Neovim, press `<space>` and confirm which-key shows the `t` group labeled "Todo / Terminal"; confirm `Ctrl+Left/Right/Up/Down` still resize splits as before (no behavior change, comment-only).

- [ ] **Step 6: Commit**

```bash
git add dot_config/nvim/lua/config/keymaps.lua dot_config/nvim/lua/plugins/whichkey.lua
git commit -m "$(cat <<'EOF'
docs: explain Neovim's arrow-resize exception, fix which-key t-group label

Comment-only change: documents why split-resize uses arrows instead of
Ctrl+hjkl (already claimed by herdr_nav.lua), and relabels the which-key
"t" group from "Todo" to "Todo / Terminal" since toggleterm's <leader>tt
lives under the same prefix.
EOF
)"
```

---

### Task 7: Create the canonical KEYBINDS.md reference

**Files:**
- Create: `KEYBINDS.md`

**Interfaces:**
- Consumes: the final (post-Task-1-through-6) state of every keybind file — this task must run after Tasks 1-6 so the tables reflect reality, not the pre-fix state.
- Produces: `KEYBINDS.md` at repo root, which Task 8 links to from `README.md`.

- [ ] **Step 1: Write `KEYBINDS.md`**

```markdown
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
```

- [ ] **Step 2: Verify the file was created and is well-formed markdown (table row/separator counts match)**

```bash
test -f KEYBINDS.md && echo "exists"
grep -c '^|---' KEYBINDS.md   # expect one separator row per table — sanity count, should be > 15
```

- [ ] **Step 3: Commit**

```bash
git add KEYBINDS.md
git commit -m "$(cat <<'EOF'
docs: add KEYBINDS.md as the canonical cross-tool keybind reference

States the constitution (HJKL as the universal directional axis,
modifier-layering by action-class) and documents every tool's bindings
plus the intentional exceptions, reflecting the fixes from the preceding
commits.
EOF
)"
```

---

### Task 8: Correct README's wlogout row and trim its Keybindings section to link to KEYBINDS.md

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: `KEYBINDS.md` (Task 7) must exist before this task runs, since the new text links to it.

- [ ] **Step 1: Baseline check**

```bash
grep -n "Session menu.*wlogout\|## Keybindings" README.md
```
Expected: the Stack table's `Session menu` row and the `## Keybindings` heading, both present.

- [ ] **Step 2: Correct the Stack table's Session menu row**

Old:
```
| **Session menu** | wlogout | - |
```
New:
```
| **Session menu** | Noctalia (`SUPER+Escape`) | wlogout (`SUPER+Ctrl+Escape`, alternative) |
```

- [ ] **Step 3: Trim the Keybindings section to a summary + link**

Old:
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
```
New:
```
## Keybindings

Every keybind across every tool — Hyprland, Neovim, herdr, Yazi, fish/atuin —
follows one shared convention: HJKL as the universal directional axis, with
modifiers layered by action-class (base = focus, `+Shift` = move, `+Ctrl` =
resize). See [`KEYBINDS.md`](KEYBINDS.md) for the full cross-tool reference
and the documented exceptions.
```

- [ ] **Step 4: Verify**

```bash
grep -n "Noctalia.*SUPER+Escape" README.md            # expect 1 match (Stack table row)
grep -n "KEYBINDS.md" README.md                        # expect 1 match (the new link)
grep -c "SUPER + H/J/K/L" README.md                     # expect 0 (old table removed)
```

- [ ] **Step 5: Commit**

```bash
git add README.md
git commit -m "$(cat <<'EOF'
docs: correct README's wlogout entry, link Keybindings section to KEYBINDS.md

wlogout was listed as the active session menu when Noctalia's own session
menu has that role now (wlogout is the SUPER+Ctrl+Escape fallback). The
Hyprland-only keybindings table is replaced with a summary + link to the
new cross-tool KEYBINDS.md, matching how the Neovim section already
defers to "see the file for full list" instead of duplicating content.
EOF
)"
```

---

## Post-implementation

All 8 tasks are independently committed. The manual verification steps in
Tasks 1-6 require the actual machine (Hyprland/herdr/Neovim/Yazi/fish running)
— run through them once all 8 commits have landed, since Task 1's wlogout
bind and Task 8's README correction both assume `wlogout` itself is
installed and configured (`dot_config/wlogout/`), which this plan does not
change.
