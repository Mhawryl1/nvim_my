local M = require "core.misc"
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- if vim.g.toggleFormating then
    --vim.cmd "wshada!"
    --vim.lsp.buf.format()
    --vim.cmd "LspZeroFormat"
    --vim.cmd "rshada!"
    --vim.defer_fn(function() vim.api.nvim_command "silent! edit " end, 100) -- reload buffer (fixes issue with display sing marks in statusline)
    --end
    require("lint").try_lint()
  end,
})

--recognize filetype for MSVC include header files (this files don't have extension)
if vim.loop.os_uname().sysname == "Windows_NT" then
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    callback = function()
      local path = vim.fn.expand "%:p"
      if path:match [[C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14%.43%.34808\include]] then
        vim.bo.filetype = "cpp"
      end
    end,
  })
end
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = "*",
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = vim.api.nvim_create_augroup("AutoOpenQuickfix", { clear = true }),
  pattern = { "[^l]*" },
  callback = function()
    M.QfMakeConv()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then return end
    vim.api.nvim_command "copen"
  end,
})

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter" }, {
  callback = function()
    local config = require("lualine").get_config()
    local lsp = require("core.utils").lspSection()
    config.sections.lualine_x[1] = lsp
    require("lualine").setup(config)
  end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function()
    local hl_format = vim.api.nvim_get_hl(0, { name = "FormatStatus" })
    local hl_lsp = vim.api.nvim_get_hl(0, { name = "LspIcon" })
    local hl_group = require("core.utils").getHLColor()
    vim.api.nvim_set_hl(0, "LSpIcon", { fg = hl_lsp.fg, bg = hl_group.bg })
    vim.api.nvim_set_hl(0, "CustomLine", { fg = hl_group.fg, bg = hl_group.bg })
    vim.api.nvim_set_hl(0, "FormatStatus", { fg = hl_format.fg, bg = hl_group.bg })
  end,
})

------make command config -----
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.opt_local.makeprg = "node %"
    vim.opt_local.errorformat = "%f: line %l, col %c, %m"
  end,
})
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "cpp",
--   callback = function()
--     vim.opt_local.makeprg = "g++ % -o %< && ./%<"
--     vim.opt_local.errorformat = "%f:%l:%c: %m"
--   end,
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "cpp",
--   callback = function() vim.api.nvim_setkeymap("n", "<C-r>", "<cmd>CMakeRun<cr>", { noremap = true, silent = true }) end,
-- })
