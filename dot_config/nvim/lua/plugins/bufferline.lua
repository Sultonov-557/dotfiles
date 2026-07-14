-- Bufferline — tab bar for buffers
return {
  "akinsho/bufferline.nvim",
  event = "UIEnter",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      mode = "buffers",
      numbers = "none",
      separator_style = "thin",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      offsets = {
        {
          filetype = "alpha",
          text = "Dashboard",
          text_align = "center",
        },
        {
          filetype = "NvimTree",
          text = "Explorer",
          text_align = "center",
        },
      },
      hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      },
    },
    highlights = {
      offset_separator = {
        fg = "#45475a",
        bg = "#11111b",
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- Auto-refresh bufferline when colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        pcall(function()
          require("bufferline").refresh()
        end)
      end,
    })
  end,
}
