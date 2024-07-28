return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "dokwork/lualine-ex",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local lualine = require "lualine"
    local utils = require "core.utils"
    local navic = require "nvim-navic"

    local config = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = " ", right = "" },
        section_separators = { left = " ", right = " " },
        disabled_filetypes = {
          statusline = {},
          winbar = { "neo-tree", "toggleterm" },
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "ex.git.branch", icon = "", disabled_icon_color = { fg = "grey" } },
          "diff",
          "diagnostics",
        },
        lualine_c = {
          "filetype",
          utils.currentDir,
          utils.macro_recording,
        },
        lualine_x = {
          { utils.spellcheck },
          { utils.spellcheck },
          "encoding",
          "fileformat",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {
        lualine_c = {
          {
            function()
              return (navic.get_location() ~= nil and #navic.get_location() > 0) and navic.get_location() or " "
            end,
            cond = function() return navic.is_available() end,
          },
        },
        lualine_x = {
          { require("auto-session.lib").current_session_name, color = { fg = "#000000", bg = "#b8bb26" } },
        },
      },
      inactive_winbar = {},
      extensions = { "quickfix", "neo-tree" },
    }
    lualine.setup(config)
  end,
}
