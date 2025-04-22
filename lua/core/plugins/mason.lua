if true then return {} end
return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "mfussenegger/nvim-dap",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local mason_lspconfig = require "mason-lspconfig"
    local mason_tool_installer = require "mason-tool-installer"
    local mason_dap = require "mason-nvim-dap"
    require("mason").setup {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }
    mason_lspconfig.setup(require("plugins.config.lsp_config").servers)
    mason_lspconfig.setup_handlers(require("plugins.config.lsp_config").handlers)
    mason_tool_installer.setup(require("plugins.config.lsp_config").tools)

    mason_dap.setup {
      ensure_installed = {
        "node",
        "python",
        "cpptools",
      },
      automatic_installation = true,
      handlers = {},
    }
  end,
}
