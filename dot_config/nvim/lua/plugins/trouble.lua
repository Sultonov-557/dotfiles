-- Trouble — diagnostics list viewer
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  opts = {
    focus = false,
    win = {
      position = "right",
      size = 0.35,
    },
    preview = {
      type = "split",
      relative = "win",
      position = "bottom",
      size = 0.3,
    },
    modes = {
      lsp_references = {
        params = {
          include_declaration = true,
          include_current_line = false,
        },
      },
    },
  },
}
