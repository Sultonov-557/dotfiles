-- noice.nvim — cmdline popup & message UI
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
    },
    popupmenu = {
      enabled = true,
    },
    lsp = {
      progress = { enabled = true, view = "mini" },
      hover = { enabled = true },
      signature = { enabled = true },
      message = { enabled = true, view = "notify" },
    },
    presets = {
      bottom_search = false,
      command_palette = false,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    views = {
      cmdline_popup = {
        border = { style = "rounded" },
        position = { row = "40%", col = "50%" },
        size = { width = 60, height = "auto" },
      },
    },
  },
}
