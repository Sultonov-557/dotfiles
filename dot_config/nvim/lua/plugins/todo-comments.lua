-- Todo-comments — highlight TODO/FIXME/HACK in code + jump/search them
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "UIEnter",
  opts = {
    signs = true,
    keywords = {
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", color = "warning", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    merge_keywords = false,
    highlight = {
      multiline = true,
      multiline_indent = "  ",
      before = "",
      keyword = "wide",
    },
    search = { pattern = [[\b(KEYWORDS)\b]] },
  },
}
