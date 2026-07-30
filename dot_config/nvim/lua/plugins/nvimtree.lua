-- Nvim-tree — file explorer (replaces netrw)

-- Keep nvim-tree's defaults, but realign the create/copy/yank keys to match
-- yazi's scheme (this user's TUI file manager) so muscle memory carries over:
-- yazi uses c=create, y=yank(copy), p=paste, d=delete, r=rename.
local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  api.config.mappings.default_on_attach(bufnr)

  local opts = function(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set("n", "c", api.fs.create, opts("Create File Or Directory"))
  vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy (yank)"))
  vim.keymap.set("n", "gn", api.fs.copy.filename, opts("Copy Name"))
end

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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      on_attach = on_attach,
      filters = {
        dotfiles = true, -- hidden by default, toggle with Shift+H
        exclude = { ".env" }, -- always shown regardless of dotfile/gitignore filters
      },
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
