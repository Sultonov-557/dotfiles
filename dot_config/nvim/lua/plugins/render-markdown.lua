-- render-markdown — inline heading/code-block rendering for markdown buffers
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  opts = {
    heading = {
      sign = false,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
  },
}
