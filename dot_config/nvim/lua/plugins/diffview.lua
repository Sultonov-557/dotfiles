-- Diffview — side-by-side git diff and file history viewer
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gV", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview file history" },
  },
}
