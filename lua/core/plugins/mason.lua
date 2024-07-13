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
    mason_lspconfig.setup {
      -- list of servers for mason to install
      ensure_installed = {
        "tsserver",
        "html",
        "cssls",
        "lua_ls",
        "emmet_ls",
        "pyright",
      },
      mason_tool_installer.setup {
        ensure_installed = {
          "prettier", -- prettier formatter
          "stylua",   -- lua formatter
          "isort",    -- python formatter
          "pylint",
          "eslint_d",
          "cmakelang",
        },
      },
    }
    mason_dap.setup {
      ensure_installed = {
        "node",
        "python",
        "cpptools",
      },
      handlers = {},
    }
  end,
}
