-- Comment.nvim — custom keymaps
return {
  "numToStr/Comment.nvim",
  keys = {
    { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
    { "gb", mode = { "n", "v" }, desc = "Block comment" },
  },
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  opts = {
    toggler = { line = "<leader>cc", block = "<leader>cb" },
    opleader = { line = "<leader>c", block = "<leader>C" },
    extra = { above = "<leader>cO", below = "<leader>co", eol = "<leader>cA" },
    -- Correct comment strings inside embedded languages (e.g. JS in .vue/.jsx)
    pre_hook = function(...)
      return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(...)
    end,
  },
}
