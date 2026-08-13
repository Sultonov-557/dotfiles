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

    -- Quick-action buttons
    dashboard.section.buttons.val = {
      dashboard.button("n", "  New file", "<cmd>ene<CR>"),
      dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
      dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("g", "  Live grep", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("c", "  Config", "<cmd>edit " .. vim.fn.stdpath("config") .. "/init.lua<CR>"),
      dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
    }

    -- Footer: plugin load stats
    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    dashboard.section.footer.val = "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms"

    -- Layout: header, buttons, footer
    opts.layout = {
      { type = "padding", val = 4 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
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
