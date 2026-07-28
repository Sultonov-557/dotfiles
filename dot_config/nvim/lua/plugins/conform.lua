-- Conform — formatters for filetypes the attached LSP doesn't format well
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 2000,
    },
    formatters_by_ft = {
      rust = { "rustfmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      lua = { "stylua" },
      python = { "black" },
      caddy = { "caddy_fmt" },
    },
    formatters = {
      caddy_fmt = {
        command = "caddy",
        args = { "fmt", "-" },
        stdin = true,
      },
    },
  },
}
