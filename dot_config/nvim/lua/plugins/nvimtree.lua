-- Nvim-tree — file explorer (replaces netrw)
return {
  -- Disable neo-tree (LazyVim default explorer, unused now)
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },

  -- Enable nvim-tree instead
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", desc = "Toggle file tree" },
      { "<leader>E", desc = "Focus file tree" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      filters = { dotfiles = false },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          show = { file = true, folder = true, git = true },
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      view = {
        width = 35,
        side = "left",
        number = false,
        relativenumber = false,
      },
      actions = {
        open_file = {
          window_picker = { enable = false },
          quit_on_open = false,
        },
      },
    },
  },
}
