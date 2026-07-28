-- Undotree — visualize and navigate undo history
return {
  "mbbill/undotree",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
  },
  init = function()
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_DiffAutoOpen = 1
  end,
}
