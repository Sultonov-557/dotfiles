-- nvim-navic — LSP breadcrumb winbar
local excluded_filetypes = {
  alpha = true,
  NvimTree = true,
  TelescopePrompt = true,
  Trouble = true,
  lazy = true,
  mason = true,
  help = true,
  qf = true,
}

return {
  "SmiteshP/nvim-navic",
  lazy = true,
  init = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("NavicAttach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client.server_capabilities.documentSymbolProvider then
          return
        end
        if excluded_filetypes[vim.bo[args.buf].filetype] then
          return
        end
        local navic = require("nvim-navic")
        navic.attach(client, args.buf)
        vim.wo.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
      end,
    })
  end,
  opts = {
    highlight = true,
    separator = " › ",
    depth_limit = 5,
    icons = {
      File = "󰈔 ",
      Function = "󰊕 ",
      Method = "󰊕 ",
      Class = "󰠱 ",
      Module = " ",
      Variable = "󰀫 ",
    },
  },
  config = function(_, opts)
    require("nvim-navic").setup(opts)
  end,
}
