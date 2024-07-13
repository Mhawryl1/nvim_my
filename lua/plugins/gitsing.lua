return {
  "lewis6991/gitsigns.nvim",
  event = "VimEnter",
  config = function()
    local getIcon = require("core.assets").getIcon
    require("gitsigns").setup {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },

      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,  -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },

      on_attach = function(burnr)
        local gitsigns = require "gitsigns"
        local maps = require("core.utils").maps
        maps.n["]g"] = {
          function() gitsigns.next_hunk() end,
          { desc = "Next Git hunk" },
        }
        maps.n["[g"] = {
          function() gitsigns.prev_hunk() end,
          { desc = "Previous Git hunk" },
        }
        maps.n["<Leader>gl"] = {
          function() gitsigns.blame_line() end,
          { desc = "View Git blame" },
        }
        maps.n["<Leader>gL"] = {
          function() gitsigns.blame_line { full = true } end,
          { desc = "View full Git blame" },
        }
        maps.n["<Leader>gp"] = {
          function() gitsigns.preview_hunk_inline() end,
          { desc = "Preview Git hunk" },
        }
        maps.n["<Leader>gh"] = {
          function() gitsigns.reset_hunk() end,
          { desc = "Reset Git hunk" },
        }
        maps.n["<Leader>gr"] = {
          function() gitsigns.reset_buffer() end,
          { desc = "Reset Git buffer" },
        }
        maps.n["<Leader>gs"] = {
          function() gitsigns.stage_hunk() end,
          { desc = "Stage Git hunk" },
        }
        maps.n["<Leader>gS"] = {
          function() gitsigns.stage_buffer() end,
          { desc = "Stage Git buffer" },
        }
        maps.n["<Leader>gu"] = {
          function() gitsigns.undo_stage_hunk() end,
          { desc = "Unstage Git hunk" },
        }
        maps.n["<Leader>gd"] = {
          function() gitsigns.diffthis() end,
          { desc = "View Git diff" },
        }

        -- maps.n["]g"] = {
        -- 	function()
        -- 		require("gitsigns").next_hunk()
        -- 	end,
        -- 	desc = "Next Git hunk",
        -- }
        -- maps.n["[g"] = {
        -- 	function()
        -- 		require("gitsigns").prev_hunk()
        -- 	end,
        -- 	desc = "Previous Git hunk",
        -- }
        -- maps.n["<Leader>gl"] = {
        -- 	function()
        -- 		require("gitsigns").blame_line()
        -- 	end,
        -- 	desc = "View Git blame",
        -- }
        -- maps.n["<Leader>gL"] = {
        -- 	function()
        -- 		require("gitsigns").blame_line({ full = true })
        -- 	end,
        -- 	desc = "View full Git blame",
        -- }
        -- maps.n["<Leader>gp"] = {
        -- 	function()
        -- 		require("gitsigns").preview_hunk_inline()
        -- 	end,
        -- 	desc = "Preview Git hunk",
        -- }
        -- maps.n["<Leader>gh"] = {
        -- 	function()
        -- 		require("gitsigns").reset_hunk()
        -- 	end,
        -- 	desc = "Reset Git hunk",
        -- }
        -- maps.n["<Leader>gr"] = {
        -- 	function()
        -- 		require("gitsigns").reset_buffer()
        -- 	end,
        -- 	desc = "Reset Git buffer",
        -- }
        -- maps.n["<Leader>gs"] = {
        -- 	function()
        -- 		require("gitsigns").stage_hunk()
        -- 	end,
        -- 	desc = "Stage Git hunk",
        -- }
        -- maps.n["<Leader>gS"] = {
        -- 	function()
        -- 		require("gitsigns").stage_buffer()
        -- 	end,
        -- 	desc = "Stage Git buffer",
        -- }
        -- maps.n["<Leader>gu"] = {
        -- 	function()
        -- 		require("gitsigns").undo_stage_hunk()
        -- 	end,
        -- 	desc = "Unstage Git hunk",
        -- }
        -- maps.n["<Leader>gd"] = {
        -- 	function()
        -- 		require("gitsigns").diffthis()
        -- 	end,
        -- 	desc = "View Git diff",
        -- }
      end,
    }
  end,
}
