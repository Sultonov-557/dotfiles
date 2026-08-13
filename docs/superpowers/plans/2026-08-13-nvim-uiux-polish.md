# Neovim UI/UX Polish Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add nvim-notify, noice.nvim, tiny-inline-diagnostic.nvim, nvim-navic, an extended alpha dashboard, and neoscroll.nvim to the Neovim config, and remove dead Catppuccin integration entries (`dap`, `symbols_outline`).

**Architecture:** Each plugin is its own `lua/plugins/<name>.lua` file returning a lazy.nvim spec table, matching every existing file in this directory (`bufferline.lua`, `gitsigns.lua`, etc. — one file, one plugin, one `return { ... }`). No shared runtime module is introduced; cross-plugin wiring (e.g. noice depending on notify) is expressed via lazy.nvim's `dependencies` field, exactly as `telescope.lua` already does with `telescope-fzf-native.nvim`.

**Tech Stack:** Neovim (Lua), lazy.nvim plugin manager, Catppuccin Mocha colorscheme, chezmoi (dotfile sync).

## Global Constraints

- Spec: `docs/superpowers/specs/2026-08-13-nvim-uiux-polish-design.md`.
- Minimal/subtle visual style everywhere **except** cmdline popup (noice, fully enabled) and breadcrumbs (navic winbar, fully enabled) — both explicitly opted into by the user.
- No new global leader keymaps; no `KEYBINDS.md` changes required by this plan.
- No automated test suite exists for this config. "Testing" per task means: (a) `chezmoi apply` right after editing (chezmoi source-path is this repo, confirmed — no worktree needed), then a headless Neovim sanity check against the now-synced live config, and (b) a visual check against the exact behavior described in the spec's Testing section, which only a human at a real terminal can perform — collected into one checklist handed to the user after all tasks land, not delegated to a subagent with no screen.
- Edits happen in `dot_config/nvim/` under the chezmoi source (`/home/sultonov/dotfiles`); each task applies to live `~/.config/nvim` via `chezmoi apply` as part of its own verification, not deferred to a final task.
- Commit after every task with a `feat:`/`fix:`/`chore:` prefix matching this repo's existing commit style (see `git log --oneline -10`).

---

### Task 1: Cleanup — remove dead Catppuccin integrations

**Files:**
- Modify: `dot_config/nvim/lua/plugins/colorscheme.lua:52-55` (the `dap` block) and `:51` (the `symbols_outline` line)

**Interfaces:**
- Consumes: nothing
- Produces: nothing (later tasks don't depend on this)

- [ ] **Step 1: Remove the `dap` and `symbols_outline` integration entries**

In `dot_config/nvim/lua/plugins/colorscheme.lua`, the `integrations` table currently has, in order: `..., lsp_trouble = true, alpha = true, notify = true, mini = {...}, noice = true, symbols_outline = true, dap = { enabled = true, enable_ui = true },`. Remove the `symbols_outline = true,` line and the whole `dap = { enabled = true, enable_ui = true },` block (both are for plugins not installed in this repo). Leave `notify = true` and `noice = true` in place — Tasks 2 and 3 install those plugins.

Resulting `integrations` table tail should read:

```lua
        lsp_trouble = true,
        alpha = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "mauve",
        },
        noice = true,
      },
```

- [ ] **Step 2: Headless sanity check**

Run: `nvim --headless -c "lua dofile('dot_config/nvim/lua/plugins/colorscheme.lua')" -c "qa"` from the repo root.
Expected: exits cleanly, no Lua error printed.

- [ ] **Step 3: Commit**

```bash
cd /home/sultonov/dotfiles
git add dot_config/nvim/lua/plugins/colorscheme.lua
git commit -m "chore(nvim): remove dead dap/symbols_outline catppuccin integrations"
```

---

### Task 2: Notifications — nvim-notify

**Files:**
- Create: `dot_config/nvim/lua/plugins/notify.lua`

**Interfaces:**
- Consumes: nothing
- Produces: global `vim.notify` is replaced by `require("notify")` — Task 3 (noice.lua) depends on `rcarriga/nvim-notify` being present as a dependency and routes its `messages`/`lsp.progress` views through it via noice's own `view = "notify"` opts (noice calls `vim.notify` internally, no direct API coupling needed here).

- [ ] **Step 1: Create the plugin spec**

`dot_config/nvim/lua/plugins/notify.lua`:

```lua
-- nvim-notify — toast notifications
return {
  "rcarriga/nvim-notify",
  lazy = false,
  priority = 900,
  opts = {
    timeout = 3000,
    render = "compact",
    stages = "fade",
    top_down = true,
    background_colour = "#1e1e2e",
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
```

(`background_colour` matches the `NormalFloat`/`FloatBorder` override already in `colorscheme.lua:59-60`, so toasts don't show a mismatched background on a transparent terminal.)

- [ ] **Step 2: Headless install + sanity check**

Run: `nvim --headless "+Lazy! sync" +qa` from a shell where `NVIM_APPNAME` is unset (uses the real config at `~/.config/nvim` — see Task 8 for syncing the chezmoi source there first if this is run before `chezmoi apply`; if testing straight from the source tree, point `XDG_CONFIG_HOME` at a temp copy or run this check after Task 8's `chezmoi apply`).
Expected: `nvim-notify` clones successfully, command exits without error output.

- [ ] **Step 3: Manual check**

Open `nvim`, run `:lua vim.notify("test message", vim.log.levels.WARN)`. Expected: a small popup toast appears near the top-right (or configured corner), auto-dismisses after ~3s — not a `:messages`-style bottom-line echo.

- [ ] **Step 4: Commit**

```bash
cd /home/sultonov/dotfiles
git add dot_config/nvim/lua/plugins/notify.lua
git commit -m "feat(nvim): add nvim-notify for toast notifications"
```

---

### Task 3: Cmdline & messages — noice.nvim

**Files:**
- Create: `dot_config/nvim/lua/plugins/noice.lua`

**Interfaces:**
- Consumes: `rcarriga/nvim-notify` (Task 2) as a `dependencies` entry — noice routes messages through whatever `vim.notify` is set to.
- Produces: nothing further tasks depend on.

- [ ] **Step 1: Create the plugin spec**

`dot_config/nvim/lua/plugins/noice.lua`:

```lua
-- noice.nvim — cmdline popup & message UI
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
    },
    popupmenu = {
      enabled = true,
    },
    lsp = {
      progress = { enabled = true, view = "mini" },
      hover = { enabled = true },
      signature = { enabled = true },
      message = { enabled = true, view = "notify" },
    },
    presets = {
      bottom_search = false,
      command_palette = false,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    views = {
      cmdline_popup = {
        border = { style = "rounded" },
        position = { row = "40%", col = "50%" },
        size = { width = 60, height = "auto" },
      },
    },
  },
}
```

`command_palette = false` keeps a single centered popup for `:` instead of the two-pane cmdline+results layout, matching the "minimal" preference elsewhere while still honoring the explicit ask for a popup cmdline. `lsp.progress.view = "mini"` keeps LSP progress as a small corner indicator rather than a chatty message stream.

- [ ] **Step 2: Headless install + sanity check**

Run: `nvim --headless "+Lazy! sync" +qa` (same caveat as Task 2 Step 2 about config location).
Expected: `noice.nvim` and `nui.nvim` clone successfully, no error output.

- [ ] **Step 3: Manual check**

Open `nvim`, press `:`. Expected: a floating popup with rounded border appears near the center of the screen for command input, instead of text on the bottom status line. Type `echo "hi"` and press Enter — the message should route through the notify popup from Task 2, not a bottom-line echo.

- [ ] **Step 4: Commit**

```bash
cd /home/sultonov/dotfiles
git add dot_config/nvim/lua/plugins/noice.lua
git commit -m "feat(nvim): add noice.nvim for popup cmdline and messages"
```

---

### Task 4: Diagnostics — tiny-inline-diagnostic.nvim

**Files:**
- Create: `dot_config/nvim/lua/plugins/diagnostics.lua`

**Interfaces:**
- Consumes: nothing
- Produces: nothing further tasks depend on. Disables `vim.diagnostic.config({ virtual_text = ... })` globally — later tasks/edits to diagnostic config should be aware default virtual_text is off.

- [ ] **Step 1: Create the plugin spec**

`dot_config/nvim/lua/plugins/diagnostics.lua`:

```lua
-- tiny-inline-diagnostic.nvim — compact single-line inline diagnostics
return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach",
  priority = 1000,
  opts = {
    preset = "minimal",
    options = {
      show_source = false,
      multilines = false,
      multiple_diag_under_cursor = true,
    },
  },
  config = function(_, opts)
    require("tiny-inline-diagnostic").setup(opts)
    vim.diagnostic.config({ virtual_text = false })
  end,
}
```

- [ ] **Step 2: Headless install + sanity check**

Run: `nvim --headless "+Lazy! sync" +qa`.
Expected: `tiny-inline-diagnostic.nvim` clones successfully, no error output.

- [ ] **Step 3: Manual check**

Open a Lua file in the repo (LSP: `lua_ls` is configured in `lsp.lua`), introduce an obvious error (e.g. an unclosed string), save. Expected: a single-line diagnostic appears inline at end of the offending line with an icon and short message — not a multi-line default virtual-text block, and the line above/below isn't visually pushed. Confirm `[d`/`]d` (from `keymaps.lua:93-94`) still jump between diagnostics, and `<leader>d` (`keymaps.lua:92`) still opens the hover float with a rounded border.

- [ ] **Step 4: Commit**

```bash
cd /home/sultonov/dotfiles
git add dot_config/nvim/lua/plugins/diagnostics.lua
git commit -m "feat(nvim): add tiny-inline-diagnostic.nvim for compact diagnostics"
```

---

### Task 5: Breadcrumbs — nvim-navic winbar

**Files:**
- Create: `dot_config/nvim/lua/plugins/navic.lua`

**Interfaces:**
- Consumes: nothing
- Produces: sets `vim.wo.winbar` per-window on `LspAttach` for buffers whose filetype isn't in the exclusion list below. No other task reads this.

- [ ] **Step 1: Create the plugin spec**

`dot_config/nvim/lua/plugins/navic.lua`:

```lua
-- nvim-navic — LSP breadcrumb winbar
local excluded_filetypes = {
  alpha = true,
  NvimTree = true,
  TelescopePrompt = true,
  Trouble = true,
  lazy = true,
  mason = true,
  help = true,
  qf = true,
}

return {
  "SmiteshP/nvim-navic",
  lazy = true,
  init = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("NavicAttach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client.server_capabilities.documentSymbolProvider then
          return
        end
        if excluded_filetypes[vim.bo[args.buf].filetype] then
          return
        end
        local navic = require("nvim-navic")
        navic.attach(client, args.buf)
        vim.wo.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
      end,
    })
  end,
  opts = {
    highlight = true,
    separator = " › ",
    depth_limit = 5,
    icons = {
      File = "󰈔 ",
      Function = "󰊕 ",
      Method = "󰊕 ",
      Class = "󰠱 ",
      Module = " ",
      Variable = "󰀫 ",
    },
  },
  config = function(_, opts)
    require("nvim-navic").setup(opts)
  end,
}
```

- [ ] **Step 2: Headless install + sanity check**

Run: `nvim --headless "+Lazy! sync" +qa`.
Expected: `nvim-navic` clones successfully, no error output.

- [ ] **Step 3: Manual check**

Open a Lua file with a function, move the cursor inside it. Expected: a winbar line appears above the buffer window showing something like ` config.lua › 󰊕 my_function`, updating as the cursor moves between scopes. Open the alpha dashboard (`:enew` then check no winbar appears there) and `NvimTreeToggle` (confirm no winbar in the tree panel either).

- [ ] **Step 4: Commit**

```bash
cd /home/sultonov/dotfiles
git add dot_config/nvim/lua/plugins/navic.lua
git commit -m "feat(nvim): add nvim-navic breadcrumb winbar"
```

---

### Task 6: Dashboard — extend alpha.lua

**Files:**
- Modify: `dot_config/nvim/lua/plugins/alpha.lua` (full file rewrite of the `opts` function)

**Interfaces:**
- Consumes: `require("lazy").stats()` (built into lazy.nvim, no new dependency)
- Produces: nothing further tasks depend on.

- [ ] **Step 1: Replace the file contents**

`dot_config/nvim/lua/plugins/alpha.lua`:

```lua
-- Alpha — dashboard / greeter
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    local dashboard = require("alpha.themes.dashboard")

    -- Minimal NEOVIM header
    dashboard.section.header.val = {
      "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
    }

    -- Quick-action buttons
    dashboard.section.buttons.val = {
      dashboard.button("n", "  New file", "<cmd>ene<CR>"),
      dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
      dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("g", "  Live grep", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("c", "  Config", "<cmd>edit " .. vim.fn.stdpath("config") .. "/init.lua<CR>"),
      dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
    }

    -- Footer: plugin load stats
    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    dashboard.section.footer.val = "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms"

    -- Layout: header, buttons, footer
    opts.layout = {
      { type = "padding", val = 4 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    return opts
  end,
  config = function(_, opts)
    require("alpha").setup(opts)

    -- Disable colorcolumn on dashboard
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt.colorcolumn = ""
      end,
    })
  end,
}
```

Note: `stats.startuptime` reflects plugin load progress at the moment alpha's `opts` function runs (during `VimEnter`, after most startup-time plugins have already loaded) — it's a rough "how fast did this session boot" indicator, not a live-updating counter. That's an accepted simplification; a `LazyDone`-autocmd-based live refresh was considered and dropped to avoid depending on an event-ordering assumption relative to `VimEnter`.

- [ ] **Step 2: Headless sanity check**

Run: `nvim --headless -c "lua dofile('dot_config/nvim/lua/plugins/alpha.lua')" -c "qa"` from the repo root.
Expected: exits cleanly, no Lua error (this only checks the returned table is syntactically valid Lua — the `opts` function itself needs a live lazy.nvim runtime to execute, checked in Step 3).

- [ ] **Step 3: Manual check**

Start `nvim` with no file argument. Expected: header, then buttons (`n`/`f`/`r`/`g`/`c`/`q`) below it, then a footer line like `⚡ 42/42 plugins loaded in 35.2ms`. Press `f` — confirm it opens Telescope find_files. Press `q` on the dashboard — confirm it quits.

- [ ] **Step 4: Commit**

```bash
cd /home/sultonov/dotfiles
git add dot_config/nvim/lua/plugins/alpha.lua
git commit -m "feat(nvim): add quick-action buttons and footer stats to alpha dashboard"
```

---

### Task 7: Smooth scroll — neoscroll.nvim

**Files:**
- Create: `dot_config/nvim/lua/plugins/scroll.lua`

**Interfaces:**
- Consumes: nothing
- Produces: nothing further tasks depend on.

**Deviation from spec:** the design doc's component 6 mentions easing search-jump (`n`/`N`) as well as `Ctrl-d/u/f/b`. `keymaps.lua:42-43` already maps `n`/`N` to `nzzzv`/`Nzzzv` (instant jump + center). Re-mapping them here to call `neoscroll`'s animation functions would silently override that existing, working mapping from a second file, which is exactly the kind of cross-file keymap clobbering the comment in `telescope.lua:7-13` warns about avoiding. This task sticks to `neoscroll`'s built-in `mappings` list for `Ctrl-d/u/f/b` and `zt/zz/zb` only, leaving `n`/`N` untouched.

- [ ] **Step 1: Create the plugin spec**

`dot_config/nvim/lua/plugins/scroll.lua`:

```lua
-- neoscroll.nvim — smooth scrolling
return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  opts = {
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = true,
    cursor_scrolls_alone = true,
    easing = "quadratic",
    performance_mode = false,
  },
}
```

- [ ] **Step 2: Headless install + sanity check**

Run: `nvim --headless "+Lazy! sync" +qa`.
Expected: `neoscroll.nvim` clones successfully, no error output.

- [ ] **Step 3: Manual check**

Open a file longer than one screen. Press `Ctrl-d` / `Ctrl-u`. Expected: the view eases/animates to the new scroll position over a few frames instead of jumping instantly. Confirm `n`/`N` still behave as before (instant jump + center, from `keymaps.lua`) — unaffected by this task.

- [ ] **Step 4: Commit**

```bash
cd /home/sultonov/dotfiles
git add dot_config/nvim/lua/plugins/scroll.lua
git commit -m "feat(nvim): add neoscroll.nvim for smooth scrolling"
```

---

### Task 8: Sync to live config

**Files:**
- None (no source changes — this applies the already-committed changes from Tasks 1–7)

**Interfaces:**
- Consumes: all prior tasks' committed changes
- Produces: nothing

- [ ] **Step 1: Check chezmoi status before applying**

Run: `chezmoi status` from anywhere.
Expected: shows pending changes limited to the files touched in Tasks 1–7 (`colorscheme.lua`, `notify.lua`, `noice.lua`, `diagnostics.lua`, `navic.lua`, `alpha.lua`, `scroll.lua`). If it shows unrelated pending changes, stop and ask before proceeding — those are someone else's in-progress edits, not part of this plan.

- [ ] **Step 2: Apply**

Run: `chezmoi apply -v`.
Expected: the same file list is written to `~/.config/nvim/...`, command exits 0.

- [ ] **Step 3: Full interactive smoke test**

Open `nvim` for real (not headless). Re-run the manual checks from Tasks 2, 3, 4, 5, 6, and 7 against the live config in one sitting: notify toast, noice cmdline popup, compact inline diagnostic, navic winbar, alpha dashboard buttons/footer, smooth `Ctrl-d`/`Ctrl-u`. Fix forward (new commits) if anything regressed when combined, rather than amending earlier commits.

- [ ] **Step 4: Confirm no drift remains**

Run: `chezmoi status`.
Expected: empty output (no pending diffs) for the files touched by this plan.
