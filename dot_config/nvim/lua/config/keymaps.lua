-- =============================================================================
-- Keymaps — all keybindings in one place
-- =============================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── General ─────────────────────────────────────────────────────────────────

-- Escape alternatives
map("i", "jk", "<ESC>", opts)
map("i", "kj", "<ESC>", opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize splits
map("n", "<C-Left>", "<C-w><", opts)
map("n", "<C-Right>", "<C-w>>", opts)
map("n", "<C-Up>", "<C-w>+", opts)
map("n", "<C-Down>", "<C-w>-", opts)

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
map("n", "<leader>w", "<cmd>w<CR>", opts)
map("n", "<leader>q", "<cmd>wq<CR>", opts)
map("n", "<leader>Q", "<cmd>q!<CR>", opts)

-- Clear search highlights
map("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Terminal escape
map("t", "<Esc>", "<C-\\><C-n>", opts)
map("t", "jk", "<C-\\><C-n>", opts)

-- ── LSP ──────────────────────────────────────────────────────────────────────
-- These use vim.lsp.buf.* which is always available (no-op without a client).

map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gD", vim.lsp.buf.declaration, opts)
map("n", "gi", vim.lsp.buf.implementation, opts)
map("n", "gr", vim.lsp.buf.references, opts)
map("n", "K", vim.lsp.buf.hover, opts)
map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
map("n", "<leader>d", vim.diagnostic.open_float, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, opts)

-- ── Gitsigns ─────────────────────────────────────────────────────────────────
-- Lazy-load gitsigns on first use via require() inside the callback.

local gitsigns = function()
  return require("gitsigns")
end

map("n", "<leader>gb", function()
  gitsigns().blame_line()
end, opts)
map("n", "<leader>gp", function()
  gitsigns().preview_hunk()
end, opts)
map("n", "<leader>gd", function()
  gitsigns().diffthis()
end, opts)
map("n", "<leader>gD", function()
  gitsigns().diffthis("~")
end, opts)
map("n", "<leader>gr", function()
  gitsigns().reset_hunk()
end, opts)
map("v", "<leader>gr", function()
  gitsigns().reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, opts)
map("n", "<leader>gR", function()
  gitsigns().reset_buffer()
end, opts)
map("n", "<leader>gu", function()
  gitsigns().undo_stage_hunk()
end, opts)

-- ── Toggleterm ───────────────────────────────────────────────────────────────

map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", opts)
map("n", "<C-\\>", "<cmd>ToggleTerm direction=float<CR>", opts)

-- ── Nvim-tree ────────────────────────────────────────────────────────────────

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)
map("n", "<leader>E", "<cmd>NvimTreeFocus<CR>", opts)
