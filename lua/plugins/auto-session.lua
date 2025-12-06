return {
  {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    enabled = function()
      -- Disable if Kitty Scrollback mode is active
      return vim.env.KITTY_SCROLLBACK_NVIM ~= "true"
    end,
    config = function()
      local maps = require("core.utils").maps
      require("auto-session").setup {
        log_level = "error",
        root_dir = vim.fn.stdpath "data" .. "/tmp/auto_session/",
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        auto_restore_last_session = false,
        cwd_change_handling = false,
        session_lens = {
          -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
          buftypes_to_ignore = {}, -- list of buffer types that should not be deleted from current session when a new one is loaded
        },
      }
      -- Set mapping for searching a session. ⚠️ This will only work if Telescope.nvim is installed
      maps.n["<leader>so"] = {
        "<cmd>AutoSession search<cr>",
        { noremap = true, desc = "Open session" },
      }
      maps.n["<leader>ss"] = {
        "<cmd>AutoSession save<cr>",
        { noremap = true, desc = "Save session" },
      }
      maps.n["<leader>sD"] = {
        "<cmd>AutoSession deletePicker<cr>",
        { noremap = true, desc = "Find and delete session" },
      }
      maps.n["<leader>sd"] = {
        "<cmd>AutoSession delete<cr>",
        { noremap = true, desc = "Delete current session" },
      }
      maps.n["<leader>sr"] = {
        "<cmd>AutoSession restore<cr>",
        { noremap = true, desc = "Restore session" },
      }
      maps.n["<leader>st"] = {
        "<cmd>AutoSession toggle<cr>",
        { noremap = true, desc = "Toggle autosave" },
      }
    end,
  },
}
