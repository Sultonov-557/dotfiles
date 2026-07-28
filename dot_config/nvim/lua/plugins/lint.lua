-- nvim-lint — linters for filetypes without (or in addition to) LSP diagnostics
return {
  "mfussenegger/nvim-lint",
  event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      bash = { "shellcheck" },
      sh = { "shellcheck" },
      markdown = { "vale" },
      go = { "golangcilint" },
      dockerfile = { "hadolint" },
      lua = { "luacheck" },
      python = { "pylint" },
      yaml = { "yamllint" },
    }

    local augroup = vim.api.nvim_create_augroup("Lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
