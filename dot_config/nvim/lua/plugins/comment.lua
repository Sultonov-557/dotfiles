-- Comment.nvim — custom keymaps
return {
  "numToStr/Comment.nvim",
  keys = {
    { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
    { "gb", mode = { "n", "v" }, desc = "Block comment" },
  },
  opts = {
    toggler = { line = "<leader>cc", block = "<leader>cb" },
    opleader = { line = "<leader>c", block = "<leader>C" },
    extra = { above = "<leader>cO", below = "<leader>co", eol = "<leader>cA" },
  },
}
