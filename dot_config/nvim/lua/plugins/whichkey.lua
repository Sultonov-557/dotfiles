-- Which-key — keybinding helper
return {
  "folke/which-key.nvim",
  opts = {
    plugins = {
      spelling = true,
      presets = { operators = false },
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = " ",
    },
    window = {
      border = "rounded",
    },
  },
}
