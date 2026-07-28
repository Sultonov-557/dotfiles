-- Editing extras — text objects, surround, comment-string awareness in embedded languages
return {
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = {},
  },
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },
}
