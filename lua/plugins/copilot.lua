return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "BufEnter",
  opts = function(_, opts)
    vim.notify("copilot.lua loaded", vim.log.levels.INFO, { title = "Plugins" })
    local cmp, copilot = require "blink-cmp", require "copilot.suggestion"
    opts.suggestion = { auto_trigger = true, debounce = 150 }

    vim.api.nvim_set_keymap("i", "<S-Tab>", "", {
      callback = function()
        if copilot.is_visible() and not cmp.visible() then
          copilot.accept()
        else
          return "<S-Tab>"
        end
      end,
      desc = "Accept Copilot suggestion",
    })
    vim.api.nvim_set_keymap("i", "<C-l>", "", {
      callback = function()
        if copilot.is_visible() then
          copilot.accept()
        else
          return "<C-l>"
        end
      end,
      desc = "Accept Copilot suggestion",
    })
    vim.api.nvim_set_keymap("i", "<C-f>", "", {
      callback = function()
        if copilot.is_visible() then
          copilot.next()
        else
          return "<C-f>"
        end
      end,
      desc = "Next Copilot suggestion",
    })
    vim.api.nvim_set_keymap("i", "<C-b>", "", {
      callback = function()
        if copilot.is_visible() then
          copilot.prev()
        else
          return "<C-b>"
        end
      end,
      desc = "Prev Copilot suggestion",
    })
    vim.api.nvim_set_keymap("i", "<C-t>", "", {
      callback = function() copilot.toggle() end,
      desc = "Toggle Copilot",
    })
    vim.api.nvim_set_keymap("i", "<C-d>", "", {
      callback = function() copilot.dismiss() end,
      desc = "Dismiss Copilot",
    })
    return opts
  end,
}
