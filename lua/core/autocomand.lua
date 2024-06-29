vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function()
    if vim.g.toggleFormating then
      vim.lsp.buf.format()
    end
  end,
})
