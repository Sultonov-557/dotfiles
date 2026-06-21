-- =============================================================================
-- Keymaps — all keybindings in one place
-- =============================================================================
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ── General ─────────────────────────────────────────────────────────────────

-- Escape alternatives
map("i", "jk", "<ESC>", opts)
map("i", "kj", "<ESC>", opts)

-- Better command-line navigation
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-e>", "<End>", opts)
map("c", "<C-b>", "<Left>", opts)
map("c", "<C-f>", "<Right>", opts)

-- Quick file navigation
map("n", "<leader><leader>", vim.cmd.bprevious, opts)
map("n", "<tab>", "<cmd>bnext<CR>", opts)
map("n", "<S-tab>", "<cmd>bprevious<CR>", opts)

-- Better escape from terminal
map("t", "<Esc>", "<C-\\><C-n>", opts)
map("t", "jk", "<C-\\><C-n>", opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
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

-- ── Telescope ─────────────────────────────────────────────────────────────────

local telescope = function()
  return require("telescope.builtin")
end

map("n", "<leader>ff", function()
  telescope().find_files()
end, { desc = "Find files" })
map("n", "<leader>fg", function()
  telescope().live_grep()
end, { desc = "Live grep" })
map("n", "<leader>fb", function()
  telescope().buffers()
end, { desc = "Buffers" })
map("n", "<leader>fh", function()
  telescope().help_tags()
end, { desc = "Help tags" })
map("n", "<leader>fr", function()
  telescope().oldfiles()
end, { desc = "Recent files" })
map("n", "<leader>fk", function()
  telescope().keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>fq", function()
  telescope().quickfix()
end, { desc = "Quickfix" })
map("n", "<leader>fs", function()
  telescope().treesitter()
end, { desc = "Treesitter symbols" })
map("n", "<leader>fd", function()
  telescope().diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>f.", function()
  telescope().resume()
end, { desc = "Resume last picker" })

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

-- ── Which-key registration for LSP/gitsigns ──────────────────────────────────
-- This provides human-readable descriptions in the which-key popup.
-- The maps themselves are already defined above; these just register descriptions.

local wk = require("which-key")

wk.add({
  { "<leader>c",  group = "Comment" },
  { "<leader>f",  group = "Telescope" },
  { "<leader>g",  group = "Git" },
  { "<leader>t",  group = "Todo" },
  { "<leader>x",  group = "Trouble" },
  { "<leader>w",  group = "Session" },
})
