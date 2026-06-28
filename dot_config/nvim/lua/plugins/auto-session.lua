-- auto-session — Save/restore nvim sessions per project
return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    suppressed_dirs = { "~/", "/tmp", "~/.local/share/chezmoi" },
    log_level = "error",
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_suppress_dirs = { "~/", "/tmp" },
  },
  keys = {
    { "<leader>wr", "<cmd>SessionRestore<CR>",     desc = "Restore session" },
    { "<leader>ws", "<cmd>SessionSave<CR>",         desc = "Save session" },
    { "<leader>wd", "<cmd>SessionDelete<CR>",       desc = "Delete session" },
    { "<leader>wl", "<cmd>SessionSearch<CR>",       desc = "Search sessions" },
  },
}
