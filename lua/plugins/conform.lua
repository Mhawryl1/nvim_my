return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>f",
      function() require("conform").format { async = true } end,
      mode = "",
      desc = "Format buffer",
    },
  },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "biome" },
      typescript = { "biome" },
      html = { "prettierd" },
      css = { "prettierd" },
      cpp = { "clang-format" },
      cmake = { "cmake_format" },
    },
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },

    -- Set up format-on-save
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if not vim.g.toggleFormating or vim.b[bufnr].disable_autoformat then return end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    -- Customize formatters
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2" },
      },
      clang_format = {
        filetypes = { "cpp", "c", "objc" },
        args = { "--fallback-style=LLVM" },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
