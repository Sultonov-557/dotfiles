-- neoscroll.nvim — smooth scrolling
return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  opts = {
    mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = true,
    cursor_scrolls_alone = true,
    easing = "quadratic",
    performance_mode = false,
  },
}
