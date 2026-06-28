-- =============================================================================
-- Autocmds — user-defined autocommands
-- =============================================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Auto-resize windows on terminal resize
autocmd("VimResized", {
  group = augroup("WindowResize", { clear = true }),
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Return to last cursor position
autocmd("BufReadPost", {
  group = augroup("CursorPos", { clear = true }),
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Highlight yank
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Auto-create dirs on save
autocmd("BufWritePre", {
  group = augroup("AutoCreateDir", { clear = true }),
  pattern = "*",
  callback = function()
    local file = vim.fn.expand("<afile>:p:h")
    if file and #file > 0 then
      vim.fn.mkdir(file, "p")
    end
  end,
})

-- Format on save (async, only if an LSP client is attached)
autocmd("BufWritePre", {
  group = augroup("FormatOnSave", { clear = true }),
  pattern = "*",
  callback = function()
    local clients = vim.lsp.get_clients({
      bufnr = 0,
      filter = function(client)
        return client.supports_method("textDocument/formatting")
      end,
    })
    if #clients > 0 then
      vim.lsp.buf.format({ bufnr = 0, async = false })
    end
  end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = augroup("CloseWithQ", { clear = true }),
  pattern = { "help", "man", "qf", "lspinfo", "fugitive", "fugitiveblame" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
  end,
})
