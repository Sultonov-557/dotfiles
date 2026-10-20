return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<C-a>"] = {
          LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
          "fallback",
        },
      },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        accept_suggestion = "<C-a>",
      },
    },
  },
}
