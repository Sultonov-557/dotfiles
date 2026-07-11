-- Alpha — dashboard / greeter
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function(_, opts)
    local dashboard = require("alpha.themes.dashboard")

    -- Custom ASCII header (RAFFLES)
    dashboard.section.header.val = {
      "██████╗  █████╗ ███████╗███████╗██╗     ██╗███╗   ██╗███████╗",
      "██╔══██╗██╔══██╗██╔════╝██╔════╝██║     ██║████╗  ██║██╔════╝",
      "██████╔╝███████║███████╗█████╗  ██║     ██║██╔██╗ ██║█████╗  ",
      "██╔══██╗██╔══██║╚════██║██╔══╝  ██║     ██║██║╚██╗██║██╔══╝  ",
      "██████╔╝██║  ██║███████║███████╗███████╗██║██║ ╚████║███████╗",
      "╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝",
    }

    -- Custom buttons
    dashboard.section.buttons.val = {
      dashboard.button("f", "    Find files", ":Telescope find_files<CR>"),
      dashboard.button("n", "    New file", ":ene <BAR> startinsert<CR>"),
      dashboard.button("r", "    Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("g", "    Grep", ":Telescope live_grep<CR>"),
      dashboard.button("e", "    File tree", ":NvimTreeToggle<CR>"),
      dashboard.button("q", "    Quit", ":qa<CR>"),
    }

    -- Layout
    opts.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    -- Disable colorcolumn on dashboard
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt.colorcolumn = ""
      end,
    })
  end,
}
