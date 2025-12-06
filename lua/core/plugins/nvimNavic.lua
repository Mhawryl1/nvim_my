return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    -- local lspconfig = require "lspconfig"
    local navic = require "nvim-navic"

    vim.lsp.config["clangd"] = {
      on_attach = function(client, bufnr) navic.attach(client, bufnr) end,
    }

    vim.lsp.config["lua_ls"] = {
      on_attach = function(client, bufnr) navic.attach(client, bufnr) end,
    }

    -- Start the servers (this replaces lspconfig.*.setup)
    vim.lsp.start(vim.lsp.config["clangd"])
    vim.lsp.start(vim.lsp.config["lua_ls"])

    -- lspconfig.clangd.setup {
    --   on_attach = function(client, bufnr) navic.attach(client, bufnr) end,
    -- }
    -- lspconfig.lua_ls.setup {
    --   on_attach = function(client, bufnr) navic.attach(client, bufnr) end,
    -- }
  end,
}
