-- Define custom diagnostic virtual text prefixes
local get_icon = require("core.assets").getIcon
local diagnostic_signs = {
  Error = get_icon("diagnostics", "Error"),
  Warn = get_icon("diagnostics", "Warning"),
  Hint = get_icon("diagnostics", "Hint"),
  Info = get_icon("diagnostics", "Information"),
}

-- Apply custom virtual text settings for diagnostics
vim.diagnostic.config {
  virtual_text = {
    prefix = function(diagnostic)
      local type = diagnostic.severity
      if type == vim.diagnostic.severity.ERROR then
        return diagnostic_signs.Error
      elseif type == vim.diagnostic.severity.WARN then
        return diagnostic_signs.Warn
      elseif type == vim.diagnostic.severity.HINT then
        return diagnostic_signs.Hint
      elseif type == vim.diagnostic.severity.INFO then
        return diagnostic_signs.Info
      end
      return "" -- Default to no prefix if type is unrecognized
    end,
    spacing = 4, -- Add some spacing between the icon and the message
  },
  -- You can also customize other diagnostic settings here
}

vim.diagnostic.config {
  float = {
    border = "rounded",
    focusable = false,
    source = true, -- Show the source of the diagnostic
    header = "",
    prefix = " ",
    style = "minimal",
  },
}

vim.api.nvim_create_user_command("NewFile", function(args) require("core.utils").new_file(args) end, {
  nargs = "?",
  desc = { "Create new file" },
})
vim.api.nvim_create_user_command("RenameFile", function() require("core.utils").rename_file() end, {
  nargs = 0,
  desc = { "Rename the current file to <new-name>" },
})

vim.api.nvim_create_user_command("DeleteFile", function(args) require("core.utils").delete_file(args) end, {
  nargs = "?",
  complete = "file",
  desc = { "Delete file" },
})
