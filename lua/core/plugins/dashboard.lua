return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    require("dashboard").setup {
      theme = "hyper", --  doom or hyper
      config = {
        header = {

          [[                                                                       ]],
          [[                                                                       ]],
          [[                                                                       ]],
          [[                                                                       ]],
          [[                                                                     ]],
          [[       ████ ██████           █████      ██                     ]],
          [[      ███████████             █████                             ]],
          [[      █████████ ███████████████████ ███   ███████████   ]],
          [[     █████████  ███    █████████████ █████ ██████████████   ]],
          [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
          [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
          [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
          [[                                                                       ]],
          [[                                                                       ]],
          [[                                                                       ]],
        },
        week_header = {
          enable = false,
        },
        shortcut = {
          { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
          {
            icon = " ",
            icon_hl = "@variable",
            desc = "Files",
            group = "Label",
            action = "Telescope find_files",
            key = "f",
          },
          {
            desc = "󱧀 Sessions",
            group = "DiagnosticHint",
            action = "SessionSearch",
            key = "s",
          },
          {
            desc = "  Nvim Config Files",
            group = "Number",
            action = "lua require'telescope.builtin'.find_files { prompt_title = 'Config Files', cwd = vim.fn.stdpath 'config', follow = true }",
            key = "c",
          },
        },
      },
    }
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
