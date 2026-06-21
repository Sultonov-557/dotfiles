-- LSP — Mason installer + lspconfig setup
return {
  -- Mason: LSP/DAP/linter installer UI
  {
    "mason-org/mason.nvim",
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
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = function()
      local lspconfig = require("lspconfig")

      -- Default capabilities (merge with cmp if available)
      local function default_capabilities()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, cmp_caps = pcall(require, "cmp_nvim_lsp")
        if ok then
          capabilities = cmp_caps.default_capabilities()
        end
        return capabilities
      end

      return {
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
        },
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = default_capabilities(),
            })
          end,
          -- Per-server overrides
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = default_capabilities(),
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
          end,
          ["rust_analyzer"] = function()
            lspconfig.rust_analyzer.setup({
              capabilities = default_capabilities(),
              settings = {
                ["rust-analyzer"] = {
                  check = { command = "clippy" },
                },
              },
            })
          end,
        },
      }
    end,
  },
}
