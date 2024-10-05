return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  dependencies = {
    -- LSP Support
    { "neovim/nvim-lspconfig" }, -- Required
    {
      "williamboman/mason.nvim",
      -- build = function()
      --   ---@diagnostic disable-next-line: param-type-mismatch
      --   pcall(vim.cmd, "MasonUpdate")
      -- end,
    },
    { "williamboman/mason-lspconfig.nvim" }, -- Optional
    -- Autocompletion
    { "hrsh7th/nvim-cmp" },                  -- Required
    { "hrsh7th/cmp-nvim-lsp" },              -- Required
    { "L3MON4D3/LuaSnip" },                  -- Required
    { "rafamadriz/friendly-snippets" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "saadparwaiz1/cmp_luasnip" },
    { "SmiteshP/nvim-navic" },
    { "onsails/lspkind.nvim" },
    { "hrsh7th/cmp-omni" },
    --{ "hrsh7th/cmp-nvim-lsp-signature-help" },
  },
  config = function()
    local lsp = require "lsp-zero"
    local navic = require "nvim-navic"
    local lspkind = require "lspkind"

    lsp.on_attach(function(client, bufnr)
      local opts = { buffer = bufnr }
      if client.server_capabilities.documentSymbolProvider then navic.attach(client, bufnr) end
      require("lsp_signature").on_attach(require("plugins.ray_x").conf, bufnr)

      vim.keymap.set({ "n", "s" }, "gr", function() vim.lsp.buf.references() end, { buffer = bufnr })

      vim.keymap.set(
        { "n", "s" },
        "gr",
        function() vim.lsp.buf.references() end,
        { buffer = bufnr, desc = "LSP Goto Reference" }
      )

      vim.keymap.set(
        { "n", "s" },
        "gd",
        function() vim.lsp.buf.definition() end,
        { buffer = bufnr, desc = "LSP Goto Definition" }
      )

      vim.keymap.set(
        { "n", "s" },
        "g<S-d>",
        function() vim.lsp.buf.declaration() end,
        { buffer = bufnr, desc = "LSP Goto Declaration" }
      )

      -- vim.keymap.set({ "n", "s" }, "<S-k>", function()
      --   vim.lsp.buf.hover()
      -- end, { buffer = bufnr, desc = "LSP Hover" })

      vim.keymap.set(
        { "n", "s" },
        "<leader>ls",
        function() vim.lsp.buf.workspace_symbol() end,
        { buffer = bufnr, desc = "LSP Workspace Symbol" }
      )

      vim.keymap.set(
        "n",
        "[d",
        function() vim.diagnostic.goto_next() end,
        vim.tbl_deep_extend("force", opts, { desc = "Next Diagnostic" })
      )

      vim.keymap.set(
        "n",
        "]d",
        function() vim.diagnostic.goto_prev() end,
        vim.tbl_deep_extend("force", opts, { desc = "Previous Diagnostic" })
      )

      vim.keymap.set(
        { "n", "s" },
        "<leader>la",
        function() vim.lsp.buf.code_action() end,
        { buffer = bufnr, desc = "LSP Code Action" }
      )

      vim.keymap.set(
        { "n", "s" },
        "<leader>lg",
        function() vim.lsp.buf.references() end,
        { buffer = bufnr, desc = "LSP References" }
      )

      vim.keymap.set(
        { "n", "s" },
        "<leader>lr",
        function() vim.lsp.buf.rename() end,
        { buffer = bufnr, desc = "LSP Rename" }
      )

      vim.keymap.set(
        "i",
        "<C-h>",
        function() vim.lsp.buf.signature_help() end,
        { buffer = bufnr, desc = "LSP Signature Help" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>lR",
        "<cmd>Telescope lsp_references<cr>",
        { desc = "Telscope search reference" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>lD",
        "<cmd>Telescope lsp_definitions<cr>",
        { desc = "LSP Telscope search definition" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>li",
        "<cmd>Telescope lsp_implementations<cr>",
        { desc = "LSP Telscope search implementations<cr>" }
      )
    end)
    vim.api.nvim_set_keymap(
      "n",
      "<leader>fq",
      '<cmd>lua require("telescope.builtin").quicklist()<cr>',
      { desc = "Quickfix list" }
    )
    ----====mason setting ====----------
    -- require("mason").setup {}
    -- require("mason-lspconfig").setup(require("plugins.config.lsp_config").servers)
    -- require("mason-lspconfig").setup_handlers(require("plugins.config.lsp_config").config)

    local cmp_action = require("lsp-zero").cmp_action()
    local cmp = require "cmp"
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
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    cmp.setup {
      completion = {
        completeopt = "menu,menuone,preview,noselect",
        autocomplete = { cmp.TriggerEvent.TextChanged },
      },
      snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "copilot" },
        --{ name = "nvim_lsp_signature_help" },
        { name = "luasnip", keyword_length = 2, max_item_count = 5 },
        { name = "buffer",  keyword_length = 3, max_item_count = 4 },
        { name = "path" },
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<C-p>"] = cmp.mapping.scroll_docs(-4),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
        ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        ["<Tab>"] = cmp_action.luasnip_supertab(),
        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
      },

      formatting = {
        fields = { "kind", "abbr", "menu" },
        expandable_indicator = true,
        format = function(entry, vim_item)
          local kind = lspkind.cmp_format { mode = "symbol_text", maxwidth = 50 } (entry, vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = " " .. (strings[1] or "") .. " "
          kind.menu = "    (" .. (strings[2] or "") .. ")"

          return kind
        end,
      },
      window = {
        completion = cmp.config.window.bordered {
          border = "rounded", -- Use 'rounded' for rounded corners
          winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:CmpCursorLine,Search:None",
        },
        documentation = cmp.config.window.bordered {
          border = "rounded", -- Use 'rounded' for rounded corners
          winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
          pumheight = 5,
        },
      },
    }
  end,
}
