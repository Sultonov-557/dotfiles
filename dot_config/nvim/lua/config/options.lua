-- =============================================================================
-- Options — global editor settings
-- =============================================================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- UI
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.colorcolumn = "100"
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldsep = "│" }
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
vim.opt.confirm = true
vim.opt.shortmess:append("sI")
vim.opt.pumheight = 10

-- Behavior
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
