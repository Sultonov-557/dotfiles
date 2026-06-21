-- Comment.nvim — custom keymaps
return {
  "numToStr/Comment.nvim",
  opts = {
    toggler = { line = "<leader>cc", block = "<leader>cb" },
    opleader = { line = "<leader>c", block = "<leader>C" },
    extra = { above = "<leader>cO", below = "<leader>co", eol = "<leader>cA" },
  },
}
