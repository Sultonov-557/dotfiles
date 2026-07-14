-- Lazygit — git UI floating terminal
return {
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  keys = {
    { "<leader>gg", desc = "LazyGit" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- Config via vim globals (plugin has no setup() function)
  init = function()
    vim.g.lazygit_floating_window_winblend = 3
    vim.g.lazygit_floating_window_scaling_factor = 0.95
    vim.g.lazygit_floating_window_corner_color = "#b4befe"
    vim.g.lazygit_floating_window_use_alpha = true
    vim.g.lazygit_show_hidden_files = true
  end,
}
