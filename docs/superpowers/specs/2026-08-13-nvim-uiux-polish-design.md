# Neovim UI/UX Polish — Design

## Context

The Neovim config (`dot_config/nvim/`) already has a fairly complete UI stack: Catppuccin Mocha, lualine, bufferline, alpha dashboard, telescope, which-key, indent-blankline, nvim-tree, trouble, gitsigns, undotree. Four gaps were identified and confirmed with the user:

1. Notifications/messages are plain `:messages` / default `vim.notify` — easy to miss, no popup cmdline.
2. Diagnostics use Neovim's default virtual text, which is verbose and reflows code.
3. Dashboard is header-only; statusline has no LSP breadcrumb context.
4. No smooth scrolling.

Also discovered in passing: `colorscheme.lua` enables Catppuccin integrations for `notify`, `noice`, `dap`, and `symbols_outline`, but none of those plugins are installed — dead config. This work makes `notify`/`noice` live and removes the other two dead entries (`dap`, `symbols_outline` are out of scope and not requested).

User preference: minimal/subtle flair overall, except cmdline popup (explicitly wants full noice cmdline replacement) and breadcrumbs (explicitly wants navic winbar) — both opted in deliberately rather than declined.

## Components

Each component is an independent unit — a new plugin file (or focused edit) that can be tested in isolation by opening Neovim and exercising the feature.

### 1. Notifications — `plugins/notify.lua`

- Add `rcarriga/nvim-notify`.
- Set as default `vim.notify` handler.
- Style: minimal — small popup, short timeout (~3s), rounded border matching existing float style (`NormalFloat`/`FloatBorder` already themed in `colorscheme.lua`).
- No config changes needed in `colorscheme.lua` — `notify = true` integration is already present and will pick this up automatically.

### 2. Cmdline & messages — `plugins/noice.lua`

- Add `folke/noice.nvim` with deps `MunifTanjim/nui.nvim` (and it wires into `nvim-notify` from component 1).
- Enable `cmdline` view (popup for `:`, `/`, `?`) and `messages`/`popupmenu` routing through it, per user's explicit choice.
- Route long/verbose messages (search count, LSP progress) through notify rather than the cmdline, keep it out of the way of normal typing.
- `noice = true` integration already present in `colorscheme.lua` — no change needed there.
- Note in spec (not a decision needed): noice intercepts `vim.ui.select`/input by default in some configs — leave that off since it wasn't asked for and would silently change telescope/other pickers' look.

### 3. Diagnostics — `plugins/diagnostics.lua`

- Add `rachartier/tiny-inline-diagnostic.nvim`.
- Disable Neovim's default diagnostic `virtual_text` (via `vim.diagnostic.config`) since tiny-inline-diagnostic replaces it; keep `signs`, `underline`, and the rounded-border hover float untouched.
- Compact one-line-per-diagnostic style, truncated message, matches "doesn't reflow code" requirement.

### 4. Breadcrumbs — `plugins/navic.lua`

- Add `SmiteshP/nvim-navic`.
- Attach on `LspAttach` only when `client.server_capabilities.documentSymbolProvider` is true.
- Set `vim.wo.winbar` to navic's formatted output for normal file buffers; skip for alpha/NvimTree/terminal/other special filetypes (reuse the same filetype-exclusion pattern already used in `indent.lua`'s `exclude.filetypes`).
- Hand-rolled winbar string (no wrapper plugin like barbecue/dropbar), consistent with this repo's preference for direct, explicit config over heavier abstractions (e.g. `alpha.lua`'s manual dashboard).

### 5. Dashboard — edit `plugins/alpha.lua`

- Keep the existing minimal NEOVIM ASCII header as-is.
- Add a buttons section below it: New file, Find file (telescope), Recent files (telescope oldfiles), Live grep (telescope), Config (edit `init.lua`), Quit — each a single buffer-local keypress inside the alpha buffer.
- Add a footer section: plugin count and startup time (both available from `lazy.nvim`'s stats API), styled subtly (dim/comment highlight).
- These are alpha-buffer-local mappings, not global leader keymaps — no `KEYBINDS.md` update required.

### 6. Smooth scroll — `plugins/scroll.lua`

- Add `karb94/neoscroll.nvim`.
- Map `<C-d>`, `<C-u>`, `<C-f>`, `<C-b>`, and search-jump commands (`n`/`N`) to eased scrolling.
- Short, subtle easing duration — no cursor-trail/animation plugin.

### 7. Cleanup — edit `plugins/colorscheme.lua`

- Remove the `dap` and `symbols_outline` integration blocks (dead config, unrelated plugins never installed).
- Leave `notify` and `noice` integration entries in place — they become meaningful once components 1–2 land.

## Testing

Config-only change with no automated test suite. Verification is manual, per component:

1. Notify: trigger an LSP hover/rename error or a long `:messages` entry, confirm a popup toast appears.
2. Noice: type `:` and `/`, confirm popup cmdline appears near cursor instead of bottom line.
3. Diagnostics: open a file with a lint/type error, confirm compact single-line inline diagnostic, no code reflow.
4. Navic: open a file with LSP attached, move cursor into a function, confirm winbar breadcrumb updates.
5. Dashboard: `:enew | Alpha` (or start with no file), confirm buttons work and footer shows plugin count/time.
6. Scroll: `Ctrl-d`/`Ctrl-u` in a long file, confirm eased (not instant) scroll.
7. Cleanup: `:messages` on startup shows no Catppuccin integration errors; `dap`/`symbols_outline` blocks absent from `colorscheme.lua`.

Then run `chezmoi apply` so changes reach the live `~/.config/nvim`, and `chezmoi status` afterward to confirm no drift remains.

## Out of scope

- Actual `nvim-dap` or `symbols-outline.nvim` installation (not requested; integration entries removed rather than fulfilled).
- Statusline (lualine) redesign — left as-is; the "statusline polish" ask is covered by the winbar/notify additions rather than lualine itself, since lualine was already judged clean/functional.
- `vim.ui.select`/`vim.ui.input` popup styling via noice — left at default to avoid unrequested visual changes to telescope/other pickers.
