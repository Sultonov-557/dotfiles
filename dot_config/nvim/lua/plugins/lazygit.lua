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
  -- Config via vim.g globals (plugin has no setup() function)
  init = function()
    vim.g.lazygit_floating_window_winblend = 3
    vim.g.lazygit_floating_window_scaling_factor = 0.95
    vim.g.lazygit_floating_window_use_alpha = true
    vim.g.lazygit_show_hidden_files = true
    -- Set border highlight to lavender
    vim.api.nvim_set_hl(0, "LazyGitBorder", { fg = "#b4befe", default = true })
  end,
}
