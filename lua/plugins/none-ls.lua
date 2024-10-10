if true then return {} end
return {
  "nvimtools/none-ls.nvim",
  config = function()
    local get_icon = require("core.assets").getIcon
    local null_ls = require "null-ls"
    local builtins = require "null-ls.builtins"
    local formatting = require("plugins.config.lsp_config").formatting
    null_ls.setup {
      debug = true,
      sources = {
        --null_ls.builtins.diagnostics.selene,
        -- null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.clang_format,
        -- null_ls.builtins.formatting.biome,
        -- null_ls.builtins.formatting.prettierd.with {
        --   filetypes = { "css", "json", "yaml", "html" },
        -- },
        -- null_ls.builtins.formatting.cmake_format,
        -- null_ls.builtins.diagnostics.cmake_lint,
      },
    }

    -- for key, value in pairs(formatting) do
    --   if builtins.formatting[key] then builtins.formatting[key].with(value) end
    -- end

    -- vim.keymap.set(
    --   "n",
    --   "<leader>bf",
    --   "<cmd>LspZeroFormat<cr>",
    --   { desc = get_icon("ui", "Format", 1) .. "format buffer" }
    -- )
  end,
}
