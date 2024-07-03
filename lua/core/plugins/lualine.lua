--if true then return {} end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "dokwork/lualine-ex",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local lualine = require("lualine")
    local utils = require("core.utils")
    local navic = require("nvim-navic")

    lualine.setup({
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = " ", right = "" },
        section_separators = { left = " ", right = " " },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
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
          { utils.currentDir },
        },
        lualine_x = {
          { utils.lspSection },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {
        lualine_c = {
          {
            function()
              return navic.get_location()
            end,
            cond = function()
              return navic.is_available()
            end,
          },
        },
      },
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
