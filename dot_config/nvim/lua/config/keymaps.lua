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

-- Quick file navigation
map("n", "<leader><space>", function()
  require("telescope.builtin").find_files()
end, vim.tbl_extend("force", opts, { desc = "Find files" }))

map("n", "<tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Terminal escape
-- Note: herdr_nav.lua (after/plugin) overrides <C-h/j/k/l> for pane-aware
-- navigation, so the window-specific mappings below are fallbacks.
map("t", "<Esc>", "<C-\\><C-n>", opts)
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

local function telescope()
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

map("n", "<leader>/", function()
  telescope().live_grep()
end, { desc = "Live grep" })

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
