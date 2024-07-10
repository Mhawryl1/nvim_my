return {
  formatting = {
    clang_format = {
      args = {
        "--style=file:~/VCode/C++/.clang-format",
        "--fallback-style=Microsoft",
      },
    },
  },
  setup = {
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
    },
    automatic_installation = true,
  },
  config = {
    lua_ls = function()
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
              path = vim.split(package.path, ";"),
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
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
      })
    end,

    clangd = function()
      require("lspconfig").clangd.setup({
        cmd = {
          "clangd",
          "--background-index",
          "--function-arg-placeholders",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--log=error",
        },
      })
    end,
  },
}
