vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function()
    if vim.g.toggleFormating then vim.lsp.buf.format() end
  end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = vim.api.nvim_create_augroup("AutoOpenQuickfix", { clear = true }),
  pattern = { "[^l]*" },
  callback = function()
    QfMakeConv()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then return end
    vim.api.nvim_command "copen"
  end,
})
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
  callback = function()
    local config = require("lualine").get_config()
    config.sections.lualine_x[1] = function() return require("core.utils").lspSection() end
    require("lualine").setup(config)
  end,
})
