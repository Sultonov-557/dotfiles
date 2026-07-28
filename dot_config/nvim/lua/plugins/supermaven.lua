-- Supermaven — AI code completion
return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  opts = {
    keymaps = {
      accept_suggestion = "<C-a>",
    },
  },
}
