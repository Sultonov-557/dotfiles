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
  opts = {
    floating_window_winblend = 3,
    floating_window_scaling_factor = 0.95,
    floating_window_corner_color = "#b4befe",
    floating_window_use_alpha = true,
    use_custom_config_file_path = false,
    show_number = false,
    show_relative_number = false,
    show_hidden_files = true,
  },
}
