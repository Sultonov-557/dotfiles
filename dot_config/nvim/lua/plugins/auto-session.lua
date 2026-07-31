-- auto-session — Save/restore nvim sessions per project
return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    suppressed_dirs = { "~/", "/tmp", "~/.local/share/chezmoi" },
    log_level = "error",
    auto_save_enabled = true,
    auto_restore_enabled = true,
  },
  keys = {
    { "<leader>sr", "<cmd>SessionRestore<CR>",     desc = "Restore session" },
    { "<leader>ss", "<cmd>SessionSave<CR>",         desc = "Save session" },
    { "<leader>sd", "<cmd>SessionDelete<CR>",       desc = "Delete session" },
    { "<leader>sl", "<cmd>SessionSearch<CR>",       desc = "Search sessions" },
  },
}
