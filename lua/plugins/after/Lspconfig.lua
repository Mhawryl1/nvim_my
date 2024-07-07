return {
  formatting = {
    clang_format = {
      extra_args = {
        "--style=Microsoft",
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
        capabilities = { offsetEncoding = "utf-8" },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
          "--cross-file-rename",
          "--function-arg-placeholders",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = require("lspconfig/util").root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
        init_options = {
          clangdFileStatus = true,
          usePlaceholders = true,
          completeUnimported = true,
          semanticHighlighting = true,
        },
      })
    end,
    lua = function()
      require("lspconfig").lspconfig.lua.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
    end,
  },
}
