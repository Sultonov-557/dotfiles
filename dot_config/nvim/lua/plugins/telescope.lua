-- Telescope — fuzzy finder
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  -- Each entry needs its own function (not just a bare lhs+desc): lazy.nvim's
  -- `keys` loader installs a real vim.keymap.set interceptor for every entry
  -- as soon as lazy.setup() runs, which happens after config/keymaps.lua — so
  -- a bare lhs+desc here would silently clobber a same-lhs mapping defined
  -- there, and since the interceptor's rhs is nil it never gets restored
  -- after first use, leaving the key producing raw motions on every press
  -- after the first. Defining the real action here avoids that entirely.
  keys = {
    {
      "<leader><space>",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help tags",
    },
    {
      "<leader>fr",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "Recent files",
    },
    {
      "<leader>fk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>fq",
      function()
        require("telescope.builtin").quickfix()
      end,
      desc = "Quickfix",
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").treesitter()
      end,
      desc = "Treesitter symbols",
    },
    {
      "<leader>fd",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>f.",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume last picker",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
    defaults = {
      prompt_prefix = "   ",
      selection_caret = "   ",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = { preview_width = 0.5 },
        vertical = { width = 0.8 },
      },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-c>"] = actions.close,
        },
      },
    },
    pickers = {
      find_files = { hidden = true },
      live_grep = { additional_args = { "--hidden", "--no-ignore" } },
    },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    -- Load fzf-native if available
    pcall(telescope.load_extension, "fzf")
  end,
}
