--if true then return {} end
return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local builtins = require("null-ls.builtins")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.selene,
        null_ls.builtins.formatting.clang_format,
      },
    })
    local formatting = require("plugins.after.Lspconfig").formatting
    for key, value in pairs(formatting) do
      if builtins.formatting[key] then
        builtins.formatting[key].with(value)
      end
      vim.notify(vim.inspect(value), vim.log.levels.INFO, { title = "clang_format" })
    end
    vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, { desc = "format buffer" })
  end,
}
