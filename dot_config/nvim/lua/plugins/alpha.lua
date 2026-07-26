-- Alpha — dashboard / greeter
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    local dashboard = require("alpha.themes.dashboard")

    -- Minimal NEOVIM header
    dashboard.section.header.val = {
      "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
      "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
      "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
      "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
      "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
      "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
    }

    -- Layout (minimal — just header)
    opts.layout = {
      { type = "padding", val = 4 },
      dashboard.section.header,
    }

    return opts
  end,
  config = function(_, opts)
    require("alpha").setup(opts)

    -- Disable colorcolumn on dashboard
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt.colorcolumn = ""
      end,
    })
  end,
}
