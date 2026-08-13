-- nvim-notify — toast notifications
return {
  "rcarriga/nvim-notify",
  lazy = false,
  priority = 900,
  opts = {
    timeout = 3000,
    render = "compact",
    stages = "fade",
    top_down = true,
    background_colour = "#1e1e2e",
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
