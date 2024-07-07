return {
  {
    "rmagatti/auto-session",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "rmagatti/session-lens",
    },
    config = function()
      local maps = require("core.utils").maps
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        -- The following are already the default values, no need to provide them if these are already the settings you want.
        auto_save_enabled = true,
        cwd_change_handling = {
          restore_upcoming_session = true,   -- Disabled by default, set to true to enable
          pre_cwd_changed_hook = nil,        -- already the default, no need to specify like this, only here as an example
          post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
            require("lualine").refresh()     -- refresh lualine so the new session name is displayed in the status bar
          end,
        },
        session_lens = {
          -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
          buftypes_to_ignore = {}, -- list of buffer types that should not be deleted from current session when a new one is loaded
        },
      })
      -- Set mapping for searching a session. ⚠️ This will only work if Telescope.nvim is installed
      maps.n["<leader>Sf"] = {
        require("auto-session.session-lens").search_session,
        { noremap = true, desc = "Load session" },
      }
      maps.n["<leader>Ss"] = {
        "<cmd>SessionSave<cr>",
        { noremap = true, desc = "Save session" },
      }
      maps.n["<leader>Sd"] = {
        "<cmd>SessionDelete<cr>",
        { noremap = true, desc = "Delete session" },
      }
      maps.n["<leader>Sr"] = {
        "<cmd>SessionRestore<cr>",
        { noremap = true, desc = "Restore session" },
      }
      maps.n["<leader>SD"] = {
        "<cmd>Autosession delete<cr>",
        { noremap = true, desc = "Delete autosession" },
      }
      maps.n["<leader>SF"] = {
        "<cmd>Autosession delete<cr>",
        { noremap = true, desc = "Search autosession" },
      }
      maps.n["<leader>Sc"] = {
        "<cmd>:lua require('session-lens').search_session()<cr>",
        { noremap = true, desc = "Switch session" },
      }
    end,
  },
}
