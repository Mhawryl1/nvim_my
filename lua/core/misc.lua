local M = {}

function M.QfMakeConv()
  local qflist = vim.fn.getqflist()
  if (qflist == nil) or (#qflist == 0) then
    print "Pattern not found"
    return
  end
  print("Found " .. #qflist .. " entries")
end

return M
