# Keybind Integration Design

Date: 2026-07-28
Status: Approved for planning

## Problem

The dotfiles system spans seven independently-configured tools (Hyprland, Neovim,
herdr, Yazi, fish, atuin, rofi/wlogout). Each tool has its own keybind scheme, and
while HJKL-based navigation is the dominant intent across most of them, it isn't
applied consistently, and a few bindings actively conflict with each other. The
goal is a system that feels like one integrated environment rather than seven
disconnected ones — every keybind traceable to one shared philosophy, muscle
memory transferring between tools, and no unexplained or dead configuration.

A full survey of every keybind currently configured (see Appendix) found:

- Three bindings inside `hyprland.lua` where the same key chord is bound to two
  different actions (a real functional bug, not just a style inconsistency).
- Directional-key inconsistencies where HJKL is used in some places and arrows in
  others for the same class of action, without a stated reason.
- A silent conflict in fish's shell config where atuin and fzf both bind `Ctrl+R`.
- atuin's history-search popup running in emacs keybind mode despite the shell
  itself running in vi mode.
- `wlogout` is fully configured and README-listed as "the" session menu, but
  nothing in the repo actually invokes it — noctalia's own session menu
  silently took over that role. Five `dot_local/bin` scripts (`volume`,
  `brightness`, `caffeine`, `dnd`, `perfmode`) overlap in purpose with
  noctalia-IPC calls that now have the keybinds instead, though the scripts
  themselves are functioning, independently useful CLI tools, not dead code.
- No single place that documents the intended convention, so "intentional" isn't
  verifiable by looking at any one file.

## Goals

- Establish one explicit, written keybind philosophy ("the constitution") that
  every tool's bindings can be checked against.
- Fix the three real Hyprland self-conflicts.
- Bring directional (HJKL) and leader/prefix-key usage in line with the
  constitution everywhere the tool's keyspace allows it, and explicitly document
  the cases where it deliberately doesn't (rather than leaving them unexplained).
- Resolve the fish/atuin vi-mode and `Ctrl+R` inconsistencies.
- Give `wlogout` a real, explicit keybind so it's a genuine documented fallback
  (matching the existing dunst/swaync pattern) instead of unreachable config,
  and correct README's Stack table to describe it accurately.
- Document the `dot_local/bin` scripts' relationship to their noctalia-IPC
  keybind equivalents in `KEYBINDS.md` rather than leaving the overlap
  unexplained — no script changes, since they're working standalone utilities,
  not dead code.
- Produce a single canonical keybind reference doc (`KEYBINDS.md`) covering every
  tool, replacing README's current Hyprland-only table with a summary + link.
- User has confirmed relearning a handful of currently-memorized bindings (Yazi's
  `j`/`k`, herdr's tab-switch keys) is acceptable — correctness wins over
  preserving current habits.

## Non-goals

- No new tools or features (no waybar, no kanshi, no Nix flake — those are
  separate TODO.md items, unrelated to keybind consistency).
- No re-theming or visual changes.
- No change to Ghostty (it intentionally owns zero keybinds — `keybind = clear`
  — and defers all multiplexing to herdr; that division of responsibility is
  correct as-is and out of scope).
- No change to rofi or Neovim's Telescope picker navigation. Both are
  text-filter list widgets (typing a query is the primary interaction), and both
  already expose `Ctrl+j`/`Ctrl+k` for row navigation — rofi via its compiled-in
  defaults (`kb-row-down`/`kb-row-up` include `Control+j`/`Control+k`), Telescope
  via its explicit insert-mode mapping. Adding raw `h`/`l` here was considered
  and rejected: it would collide with typing those letters into the filter box.

## The constitution

Two rules, stated once and applied everywhere:

1. **HJKL is the universal directional axis.** Any tool with directional
   navigation (window focus, pane focus, list movement, history search) should
   use `h`/`j`/`k`/`l` = left/down/up/right (or their nearest 1-D equivalent:
   `j`/`k` = down/up, `n`/`N` = next/previous) unless the keys are structurally
   unavailable (e.g. a text-input context where typing conflicts).

2. **Modifiers layer by action-class on top of HJKL**, applied as far as each
   tool's keyspace allows: base modifier = primary action (usually focus), `+Shift`
   = a secondary/mutating variant of the same action (usually move), `+Ctrl` = a
   tertiary variant (usually resize).

**Tiebreaker rule:** if a tool's designated layer for an action-class is already
claimed by something more fundamental, fall back to the nearest sane alternative
and *document it as an intentional exception* — do not force a collision, and do
not silently deviate without a written reason. Two exceptions are already
justified under this rule and require no code change:

- **herdr's modal resize** (`prefix+r`, then `hjkl`) instead of a held
  `+Ctrl+hjkl` chord — repeated resizing via modal mode is better terminal-mux
  UX than holding three keys per tap, and `Ctrl+hjkl` is already claimed by
  cross-app pane navigation in herdr.
- **Neovim's arrow-key split-resize** — `Ctrl+hjkl` in Neovim is already claimed
  by cross-boundary navigation between Neovim splits and herdr panes
  (`herdr_nav.lua`), so arrows are the correct fallback, not a bug.

## Concrete changes by file

### `dot_config/hypr/hyprland.lua` — 3 self-conflicts (real bugs)

| Chord | Currently bound to (conflict) | Resolution |
|---|---|---|
| `SUPER+J` | `layout("togglesplit")` **and** `focus down` | `focus down` keeps the chord (constitution's base HJKL layer owns single-key focus). Move togglesplit to `SUPER+Alt+J` (treating `+Alt` as a fourth, "layout/misc" layer) — confirmed `+Alt` is entirely unused in `hyprland.lua` today, so this chord is free. |
| `SUPER+Shift+S` | screenshot-region **and** move-window-to-special-workspace | Drop the screenshot binding on this chord (`Print` already triggers screenshot-region on its own). Move-to-special keeps `SUPER+Shift+S` — this now reads as consistent with the constitution: `SUPER+S` = toggle special workspace (base layer), `SUPER+Shift+S` = move window to special workspace (+Shift layer). |
| `SUPER+Ctrl+L` | resize (60,0) **and** `sessionMenu lock` | Resize keeps the chord (constitution's `+Ctrl` layer owns `L` = resize +x). Confirmed: noctalia's `settings.json` (`sessionMenu.powerOptions`) already exposes `"action": "lock"` as option `1` in the session menu bound to `SUPER+Escape` — the same action this binding calls. Delete the standalone `SUPER+Ctrl+L` lock binding outright as proven-redundant; no relocation needed. |

Also add a short header comment in `hyprland.lua` stating the two constitution
rules, so the convention is visible at the point future bindings get added.

### `dot_config/nvim/lua/config/keymaps.lua` and `after/plugin/herdr_nav.lua`

- No functional change to split-resize (arrows) — it's a documented exception,
  not a bug (see constitution tiebreaker above). Add a one-line comment at the
  resize mapping explaining why it's arrows and not `Ctrl+hjkl`.
- Disambiguate the which-key `t`-group label: toggleterm's `<leader>tt` and
  todo-comments' `<leader>to/tT/tn/tp` both sit under the `t` prefix with
  distinct full keychains (no functional collision), but the which-key group
  name should make clear these are two different families ("Terminal" vs
  "Todo") rather than implying one `t` group.

### `dot_config/herdr/config.toml`

- Tab-switch currently uses `Ctrl+Shift+Left/Right`, breaking herdr's own hjkl
  convention (used everywhere else in herdr: pane focus, workspace switch).
  Change to `Ctrl+Shift+H` / `Ctrl+Shift+L` for prev/next tab. (`Ctrl+hjkl` and
  `Ctrl+Alt+hjkl` are both already claimed by pane-navigation plugins;
  `Ctrl+Shift+hjkl` is free.)
- Resize-mode (`prefix+r`, then `hjkl`) is kept exactly as-is — confirmed
  intentional exception, no change.

### `dot_config/yazi/keymap.toml`

- Swap `j`/`k`: currently `j` = `arrow -1` (moves up) and `k` = `arrow 1` (moves
  down) — inverted from vim/system convention. Fix so `j` moves down, `k` moves
  up.
- Swap `n`/`N`: currently `n` = find_prev, `N` = find_next — inverted from vim
  and from Neovim's own `n`/`N` search mapping in this same dotfiles repo. Fix
  so `n` = next, `N` = previous.
- User has confirmed relearning both is acceptable.
- Leave the harmless redundant pairs (`H`/`L` duplicating `u`/`U` for
  back/forward history, `y`/`Y` both yanking, `d`/`D` both removing) as
  low-priority optional cleanup — not required for this project since they're
  redundant, not conflicting.

### `dot_config/atuin/config.toml`

- Add an explicit `keymap_mode` matching fish's vi-mode (fish runs
  `fish_vi_key_bindings`, confirmed independently by starship's configured
  `vicmd_symbol`), so the atuin search popup honors `hjkl`/`Esc` instead of
  silently defaulting to emacs-style bindings.

### `dot_config/fish/config.fish`

- Resolve the `Ctrl+R` shadow conflict between atuin (`atuin init fish`) and fzf
  (`fzf --fish`) — both currently bind it, and fzf is sourced second so it wins
  today, silently shadowing atuin. atuin is the intended primary history tool
  (fuller-featured, synced) — reorder sourcing so atuin's `Ctrl+R` binding is
  applied last and wins. fzf keeps `Ctrl+T` (file search) and `Alt+C` (cd) — no
  conflict there.

### `dot_local/bin` scripts that overlap with noctalia-IPC-bound functionality

Checked each header comment directly: `volume`, `brightness`, `caffeine`, `dnd`,
`perfmode` are plain, self-contained CLI wrappers (e.g. `volume [up|down|mute|set
N]`) with no stated relationship to Noctalia at all — they're not orphaned
fallback code, they're independently useful standalone utilities (e.g. callable
from other scripts like `flowstart`, or run manually from a terminal). Removing
them would be deleting working, harmless functionality that happens to overlap
in *purpose* with a keybind, which isn't the same as being dead. **Resolution:
keep all five scripts unchanged — no deletions.** `KEYBINDS.md` documents the
overlap explicitly: each of these has two independent invocation paths (an
interactive one via the bound keybind → noctalia IPC → on-screen display, and a
scriptable/manual one via the CLI tool directly), rather than leaving the
duplication unexplained.

### `wlogout` — genuinely unreachable, not a documented fallback

Unlike swaync (which README's Stack table explicitly labels as the fallback to
dunst), wlogout's config has no fallback framing anywhere — README currently
lists it as *the* session menu, but noctalia's own session menu (`SUPER+Escape`)
has silently taken over that role, and nothing in the repo invokes wlogout.
This is genuinely stale, not an intentional alternative like swaync is.
**Resolution: give it a real, explicit keybind** (`SUPER+Ctrl+Escape`, parallel
to `SUPER+Escape` for the primary session menu) that launches wlogout directly,
and update README's Stack table row to describe it accurately — "manual
fallback session menu (if noctalia/QuickShell isn't running)" instead of
implying it's the active one. This makes the existing config genuinely
intentional instead of removing it.

### `power-menu` script (rofi-based Lock/Logout/Suspend/Reboot/Shutdown menu)

Same category as noctalia's session menu and now also as the freshly-bound
wlogout fallback. It doesn't need its own keybind — document it in
`KEYBINDS.md` as a third manual/CLI-invokable alternative alongside wlogout,
no behavior change.

### `KEYBINDS.md` (new file, repo root)

- States the constitution (both rules + the tiebreaker) at the top.
- One section per tool (Hyprland, Neovim, herdr, Yazi, fish/atuin), each a table
  of chord → action, grouped by constitution layer where applicable.
- A short "documented exceptions" section listing herdr's modal resize and
  Neovim's arrow-key resize with their one-line justification, plus wlogout's
  new fallback keybind and the `dot_local/bin` scripts' dual-invocation-path
  relationship to their noctalia-IPC keybind equivalents.
- README.md's existing Keybindings section (currently Hyprland-only) gets
  trimmed to a short summary paragraph + link to `KEYBINDS.md`, matching how
  the Neovim section already defers to "see the file for full list" instead of
  duplicating content.

## Sequencing

One implementation plan, ordered so that each phase is independently
verifiable before the next begins:

1. Fix the 3 Hyprland self-conflicts (real bugs — highest value, lowest risk).
2. Fix herdr tab-switch keys.
3. Fix Yazi's inverted `j`/`k` and `n`/`N`.
4. Fix atuin `keymap_mode` and the fish `Ctrl+R` sourcing order.
5. Add wlogout's `SUPER+Ctrl+Escape` fallback keybind, correct README's Stack
   table entry for it, and document the `dot_local/bin` scripts' relationship
   to their noctalia-IPC equivalents.
6. Add the constitution header comment to `hyprland.lua` and the resize-exception
   comment in Neovim's keymaps.
7. Write `KEYBINDS.md` and trim README's Keybindings section to point to it.

Each phase touches a disjoint set of files, so they can be implemented and
tested independently; there's no dependency requiring a different order beyond
"bugs before documentation."

## Testing / verification

- Hyprland: `hyprctl reload` after changes; manually verify each of the three
  previously-conflicting chords now does only its intended single action, that
  `SUPER+Alt+J` triggers togglesplit, and that `SUPER+Ctrl+L` only resizes
  (lock is gone from it, reachable via `SUPER+Escape` → `1` instead).
- wlogout: verify `SUPER+Ctrl+Escape` launches it as a working fallback session
  menu.
- herdr: reload config (`prefix+Shift+r`), verify tab-switch on the new keys and
  that pane-nav/resize-mode are untouched.
- Yazi: launch and manually verify `j`/`k` and `n`/`N` now move/search in the
  expected direction.
- atuin/fish: open a new shell, trigger `Ctrl+R`, confirm atuin's popup opens
  (not fzf's) and responds to `hjkl`/`Esc`.
- No automated test suite exists for dotfiles config; verification is manual,
  per the nature of the project.

## Appendix

Full current-state keybind inventory (all tools, pre-change) is recorded in the
conversation history that produced this design and is not duplicated here in
full — `KEYBINDS.md` (the deliverable in phase 7) supersedes it as the living
reference once written.
