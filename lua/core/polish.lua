local M = {}
local function closeCurr(bufnr)
  vim.cmd("bprev")
  vim.cmd("bdelete!" .. bufnr)
end
function M.close_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call("win_findbuf", bufnr)
  local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
  local bufname = vim.fn.expand("%")
  if buf_windows.empyt then
    bufname = "Untitled"
  end

  if modified and #buf_windows == 1 then
    local confirm = vim.fn.confirm(('Save changes to "%s"?'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
    if confirm == 1 then
      if buf_windows.empty then
        return
      end
      vim.cmd.write()
      closeCurr(bufnr)
    elseif confirm == 2 then
      closeCurr(bufnr)
    else
      return
    end
  else
    closeCurr(bufnr)
  end
end

return M
