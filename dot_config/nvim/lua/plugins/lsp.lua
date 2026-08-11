-- LSP — Mason installer + lspconfig setup
return {
  -- Mason: LSP/DAP/linter installer UI
  {
    "mason-org/mason.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
      },
    },
  },

  -- mason-lspconfig: bridge between Mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "rust_analyzer",
        "gopls",
        "bashls",
        "jsonls",
        "yamlls",
        "taplo",
        "marksman",
        "html",
        "cssls",
        "tailwindcss",
        "clangd",
        "dockerls",
      },
    },
    config = function(_, opts)
      -- Default capabilities for all servers (merge with cmp if available)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_caps = pcall(require, "cmp_nvim_lsp")
      if ok then
        capabilities = cmp_caps.default_capabilities()
      end
      vim.lsp.config("*", { capabilities = capabilities })

      -- Per-server overrides
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      })

      require("mason-lspconfig").setup(opts)
    end,
  },
}
