-- =============================================================================
-- Keymaps — all keybindings in one place
-- =============================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local desc = { noremap = true, silent = true, desc = "" }

-- ── General ─────────────────────────────────────────────────────────────────

-- Escape alternatives
map("i", "jk", "<ESC>", opts)
map("i", "kj", "<ESC>", opts)

-- Better command-line navigation
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-e>", "<End>", opts)
map("c", "<C-b>", "<Left>", opts)
map("c", "<C-f>", "<Right>", opts)

-- Quick file navigation: <leader><space> is defined in plugins/telescope.lua

map("n", "<tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Terminal escape
-- Note: herdr_nav.lua (after/plugin) overrides <C-h/j/k/l> for pane-aware
-- navigation, so the window-specific mappings below are fallbacks.
-- Esc is NOT mapped here — it needs to pass through to TUI apps (lazygit, fzf, btop, yazi).
map("t", "jk", "<C-\\><C-n>", opts)

-- Resize splits
-- Arrows, not Ctrl+hjkl: Ctrl+hjkl is already claimed by herdr_nav.lua for
-- cross-boundary navigation between Neovim splits and herdr panes. This is
-- a documented exception to the HJKL convention (see KEYBINDS.md), not an
-- oversight.
map("n", "<C-Left>", "<C-w><", { desc = "Decrease split width" })
map("n", "<C-Right>", "<C-w>>", { desc = "Increase split width" })
map("n", "<C-Up>", "<C-w>+", { desc = "Increase split height" })
map("n", "<C-Down>", "<C-w>-", { desc = "Decrease split height" })

-- Keep cursor centered when jumping
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "*", "*zzzv", opts)
map("n", "#", "#zzzv", opts)
map("n", "J", "mzJ`z", opts)

-- Better paste (visual)
map("v", "p", '"_dP', opts)

-- Better indenting (visual, stay selected)
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines (visual)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Quick save / quit
map("n", "<C-s>", "<cmd>update<CR>", { desc = "Save file" })
map("i", "<C-s>", "<cmd>update<CR>", opts)
map("v", "<C-s>", "<C-c><cmd>update<CR>", opts)
map("n", "<leader>q", "<cmd>wq<CR>", { desc = "Save and quit" })
map("n", "<leader>Q", "<cmd>q!<CR>", { desc = "Force quit" })

-- Clear search highlights
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- ── Windows — <leader>w group ────────────────────────────────────────────────

map("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>wc", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })
map("n", "<leader>ww", "<C-w>w", { desc = "Cycle windows" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize window sizes" })

-- ── LSP ──────────────────────────────────────────────────────────────────────
-- These use vim.lsp.buf.* which is always available (no-op without a client).

map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- ── Gitsigns ─────────────────────────────────────────────────────────────────
-- Lazy-load gitsigns on first use via require() inside the callback.

local function gitsigns()
  return require("gitsigns")
end

map("n", "<leader>gb", function()
  gitsigns().blame_line()
end, { desc = "Git blame" })

map("n", "<leader>gp", function()
  gitsigns().preview_hunk()
end, { desc = "Preview hunk" })

map("n", "<leader>gd", function()
  gitsigns().diffthis()
end, { desc = "Git diff" })

map("n", "<leader>gD", function()
  gitsigns().diffthis("~")
end, { desc = "Git diff (index)" })

map("n", "<leader>gr", function()
  gitsigns().reset_hunk()
end, { desc = "Reset hunk" })

map("v", "<leader>gr", function()
  gitsigns().reset_hunk({ range = { vim.fn.line("."), vim.fn.line("v") } })
end, { desc = "Reset hunk (range)" })

map("n", "<leader>gR", function()
  gitsigns().reset_buffer()
end, { desc = "Reset buffer" })

map("n", "<leader>gu", function()
  gitsigns().undo_stage_hunk()
end, { desc = "Undo stage hunk" })

-- ── Toggleterm ───────────────────────────────────────────────────────────────

map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
map("n", "<C-\\>", "<cmd>ToggleTerm direction=float<CR>", { desc = "Floating terminal" })

-- ── Nvim-tree ────────────────────────────────────────────────────────────────

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>E", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file tree" })

-- ── Telescope ─────────────────────────────────────────────────────────────────
-- All Telescope bindings (including <leader><space>) live in the plugin spec
-- itself: dot_config/nvim/lua/plugins/telescope.lua's `keys` table. They can't
-- be defined here too — see the comment on that `keys` table for why.

-- ── Buffers — <leader>b group ────────────────────────────────────────────────

local function close_buffer(buf)
  local ok, err = pcall(vim.api.nvim_buf_delete, buf, {})
  if not ok then
    vim.notify(err, vim.log.levels.WARN)
  end
end

map("n", "<leader>bx", "<cmd>bdelete<CR>", { desc = "Close current buffer" })

map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      close_buffer(buf)
    end
  end
end, { desc = "Close other buffers" })

map("n", "<leader>ba", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted then
      close_buffer(buf)
    end
  end
end, { desc = "Close all buffers" })

map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- ── Lazygit ──────────────────────────────────────────────────────────────────

map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit (toggle)" })

-- ── Trouble ───────────────────────────────────────────────────────────────────

map("n", "<leader>xx", function()
  require("trouble").toggle()
end, { desc = "Trouble toggle" })

map("n", "<leader>xw", function()
  require("trouble").toggle("workspace_diagnostics")
end, { desc = "Workspace diagnostics" })

map("n", "<leader>xd", function()
  require("trouble").toggle("document_diagnostics")
end, { desc = "Document diagnostics" })

map("n", "<leader>xq", function()
  require("trouble").toggle("quickfix")
end, { desc = "Quickfix" })

map("n", "gR", function()
  require("trouble").toggle("lsp_references")
end, { desc = "LSP references" })

-- ── Todo-comments ─────────────────────────────────────────────────────────────

map("n", "<leader>to", "<cmd>TodoTrouble<CR>", { desc = "Todo (Trouble)" })
map("n", "<leader>tT", "<cmd>TodoTelescope<CR>", { desc = "Todo (Telescope)" })
map("n", "<leader>tn", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo" })

map("n", "<leader>tp", function()
  require("todo-comments").jump_prev()
end, { desc = "Prev todo" })
