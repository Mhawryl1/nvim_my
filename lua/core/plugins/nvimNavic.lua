return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    local lspconfig = require "lspconfig"
    local navic = require "nvim-navic"
    lspconfig.clangd.setup {
      on_attach = function(client, bufnr) navic.attach(client, bufnr) end,
    }
    lspconfig.lua_ls.setup {
      on_attach = function(client, bufnr) navic.attach(client, bufnr) end,
    }
  end,
}
