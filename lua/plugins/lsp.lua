return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" }, -- Required
    {
      "williamboman/mason.nvim",
      build = function()
        pcall(vim.cmd, "MasonUpdate")
      end,
    },
    { "williamboman/mason-lspconfig.nvim" }, -- Optional
    -- Autocompletion
    { "hrsh7th/nvim-cmp" },                -- Required
    { "hrsh7th/cmp-nvim-lsp" },            -- Required
    { "L3MON4D3/LuaSnip" },                -- Required
    { "rafamadriz/friendly-snippets" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
    { "SmiteshP/nvim-navic" },
  },

  config = function()
    local lsp = require("lsp-zero")
    local navic = require("nvim-navic")
    lsp.on_attach(function(client, bufnr)
      local maps = require("core.utils").maps
      local opts = { buffer = bufnr }
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end
      maps.n["gr"] = {
        function()
          vim.lsp.buf.references()
        end,
        vim.tbl_extend("force", opts, { desc = "LSP Goto Reference" }),
      }
      maps.n["gd"] = {
        function()
          vim.lsp.buf.definition()
        end,
        vim.tbl_deep_extend("force", opts, { desc = "LSP Goto Definition" }),
      }
      maps.n["<S-k>"] = {
        function()
          vim.lsp.buf.hover()
        end,
        vim.tbl_deep_extend("force", opts, { desc = "LSP Hover" }),
      }
      maps.n["<leader>ls"] = {
        function()
          vim.lsp.buf.workspace_symbol()
        end,
        vim.tbl_deep_extend("force", opts, { desc = "LSP Workspace Symbol" }),
      }
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.goto_next()
      end, vim.tbl_deep_extend("force", opts, { desc = "Next Diagnostic" }))
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.goto_prev()
      end, vim.tbl_deep_extend("force", opts, { desc = "Previous Diagnostic" }))
      maps.n["<leader>la"] = {
        function()
          vim.lsp.buf.code_action()
        end,
        vim.tbl_deep_extend("force", opts, { desc = "LSP Code Action" }),
      }
      maps.n["<leader>lg"] = {
        function()
          vim.lsp.buf.references()
        end,
        vim.tbl_deep_extend("force", opts, { desc = "LSP References" }),
      }
      maps.n["<leader>lr"] = {
        function()
          vim.lsp.buf.rename()
        end,
        vim.tbl_deep_extend("force", opts, { desc = "LSP Rename" }),
      }
      vim.keymap.set("i", "<C-h>", function()
        vim.lsp.buf.signature_help()
      end, vim.tbl_deep_extend("force", opts, { desc = "LSP Signature Help" }))
    end)
    require("mason").setup({})
    require("mason-lspconfig").setup({
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
      handlers = {
        lsp.default_setup,
        lua_ls = function()
          local lua_opts = lsp.nvim_lua_ls()
          require("lspconfig").lua_ls.setup(lua_opts)
        end,
      },
    })

    local cmp_action = require("lsp-zero").cmp_action()
    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    require("luasnip.loaders.from_vscode").lazy_load()

    -- `/` cmdline setup.
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
    ----====autopairs setting ====----------
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip", keyword_length = 2 },
        { name = "buffer",  keyword_length = 3 },
        { name = "path" },
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- ["<C-n>"] = cmp.mapping.scroll_docs(-4),
        -- ["<C-p>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
        ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        ["<Tab>"] = cmp_action.luasnip_supertab(),
        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
      }),
      window = {
        completion = cmp.config.window.bordered({
          border = "rounded", -- Use 'rounded' for rounded corners
          winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpCursorLine,Search:None",
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded", -- Use 'rounded' for rounded corners
          winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
        }),
      },
    })
  end,
}
