-- Toggleterm — floating/horizontal terminal
return {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  keys = {
    { "<leader>tt", desc = "Toggle terminal" },
    { "<C-\\>", desc = "Floating terminal" },
  },
  opts = {
    size = 20,
    open_mapping = nil,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "horizontal",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "rounded",
      winblend = 3,
    },
  },
}
