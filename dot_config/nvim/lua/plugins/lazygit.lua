-- Lazygit — git UI floating terminal
return {
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- Config via vim.g globals (plugin has no setup() function)
  init = function()
    -- winblend/alpha off: lazygit.nvim links its float to plain "Normal",
    -- which is transparent now (colorscheme.lua). Alpha-blending a
    -- full-screen ncurses redraw over a transparent background is what
    -- was corrupting the UI, so force this window fully opaque instead.
    vim.g.lazygit_floating_window_winblend = 0
    vim.g.lazygit_floating_window_scaling_factor = 0.95
    vim.g.lazygit_floating_window_use_alpha = false
    vim.g.lazygit_show_hidden_files = true

    -- Explicit (non-default) so this wins over the plugin's own
    -- `default = true` highlight calls, which link LazyGitFloat to Normal.
    -- Reapplied on every ColorScheme event since colorscheme loading
    -- (`:hi clear` under the hood) wipes whatever was set before it.
    local function set_lazygit_hl()
      vim.api.nvim_set_hl(0, "LazyGitBorder", { fg = "#b4befe", bg = "#1e1e2e" })
      vim.api.nvim_set_hl(0, "LazyGitFloat", { bg = "#1e1e2e" })
    end
    set_lazygit_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_lazygit_hl })
  end,
}
