-- Which-key — keybinding helper
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
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
    win = {
      border = "rounded",
    },
    spec = {
      { "<leader>c",  group = "Comment" },
      { "<leader>f",  group = "Telescope" },
      { "<leader>g",  group = "Git" },
      { "<leader>t",  group = "Todo" },
      { "<leader>x",  group = "Trouble" },
      { "<leader>w",  group = "Session" },
    },
  },
}
