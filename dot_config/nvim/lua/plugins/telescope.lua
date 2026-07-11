-- Telescope — fuzzy finder
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader><space>", desc = "Find files" },
    { "<leader>ff", desc = "Find files" },
    { "<leader>fg", desc = "Live grep" },
    { "<leader>fb", desc = "Buffers" },
    { "<leader>fh", desc = "Help tags" },
    { "<leader>fr", desc = "Recent files" },
    { "<leader>fk", desc = "Keymaps" },
    { "<leader>fq", desc = "Quickfix" },
    { "<leader>fs", desc = "Treesitter symbols" },
    { "<leader>fd", desc = "Diagnostics" },
    { "<leader>f.", desc = "Resume" },
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
  opts = {
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
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
          ["<C-c>"] = require("telescope.actions").close,
        },
      },
    },
    pickers = {
      find_files = { hidden = true },
      live_grep = { additional_args = { "--hidden", "--no-ignore" } },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    -- Load fzf-native if available
    pcall(telescope.load_extension, "fzf")
  end,
}
