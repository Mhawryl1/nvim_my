return {
  formatting = {
    clang_format = {
      args = {
        "--style=file:~/VCode/C++/.clang-format",
        "--fallback-style=Microsoft",
      },
    },
  },
  ---- Language servers
  servers = {
    ensure_installed = {
      "tsserver",
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
    },
    automatic_installation = true,
  },
  ---- LSP configuration
  config = {
    tsserver = function() require("lspconfig").tsserver.setup {} end,
    jsonls = function() require("lspconfig").jsonls.setup {} end,
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
    neocmake = function() require("lspconfig").neocmake.setup {} end,
    clangd = function()
      require("lspconfig").clangd.setup {
        cmd = {
          "clangd",
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
