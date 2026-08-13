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
