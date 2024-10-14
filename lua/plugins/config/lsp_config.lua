return {
  formatting = {
    -- clang_format = {
    --   args = {
    --     "--style=file:~/VCode/C++/.clang-format",
    --     "--fallback-style=Microsoft",
    --   },
    -- },
  },
  ---- Language servers
  servers = {
    ensure_installed = {
      "ts_ls",
      "eslint",
      "rust_analyzer",
      "jdtls",
      "lua_ls",
      "jsonls",
      "html",
      "elixirls",
      "tailwindcss",
      "tflint",
      "pylsp",
      "dockerls",
      "bashls",
      "marksman",
      "clangd",
      "biome",
      "neocmake",
      "emmet_ls",
      "powershell_es",
    },
    automatic_installation = true,
  },
  ---- Tools (formatters, linters, etc.)
  tools = {
    ensure_installed = {
      "prettierd",
      "stylua",
      "isort",
      "pylint",
      "eslint_d",
      "cmakelang",
      "cmakelint",
    },
    automatic_installation = true,
  },
  ---- LSP configuration
  handlers = {

    omnisharp = function() require("lspconfig").omnisharp.setup {} end,
    fsautocomplete = function() require("lspconfig").fsautocomplete.setup {} end,
    ts_ls = function() require("lspconfig").ts_ls.setup {} end,
    jsonls = function() require("lspconfig").jsonls.setup {} end,
    neocmake = function() require("lspconfig").neocmake.setup {} end,
    html = function() require("lspconfig").html.setup {} end,
    powershell_es = function() require("lspconfig").powershell_es.setup {} end,
    cssls = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      require("lspconfig").cssls.setup { capabilities = capabilities }
    end,
    emmet_ls = function() require("lspconfig").emmet_ls.setup { filetypes = { "html", "typescript" } } end,
    lua_ls = function()
      require("lspconfig").lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = vim.split(package.path, ";"),
            },
            diagnostics = {
              globals = {
                "vim",
              },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,
    clangd = function()
      require("lspconfig").clangd.setup {
        cmd = {
          "clangd",
          "--limit-results=1000",
          "--background-index",
          "--function-arg-placeholders",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--offset-encoding=utf-16",
        },
      }
    end,
  },
}
