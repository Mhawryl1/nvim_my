local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


function QfMakeConv()
  local qflist = vim.fn.getqflist()
  if (qflist == nil) or (#qflist == 0) then
    print "Pattern not found"
    return
  end
  print("Found " .. #qflist .. " entries")
end

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
