return {
  "huy-hng/anyline.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  config = function()
    require("anyline").setup {
      -- visual stuff
      indent_char = "▏", -- character to use for the line
      highlight = "NonText", -- color of non active indentation lines
      context_highlight = "ModeMsg", -- color of the context under the cursor

      -- animation stuff / fine tuning
      animation = "from_cursor", -- 'from_cursor' | 'to_cursor' | 'top_down' | 'bottom_up' | 'none'
      debounce_time = 30, -- how responsive to make to make the cursor movements (in ms, very low debounce time is kinda janky at the moment)
      fps = 30, -- changes how many steps are used to transition from one color to another
      fade_duration = 300, -- color fade speed (only used when lines_per_second is 0)
      length_acceleration = 0.02, -- increase animation speed depending on how long the context is

      lines_per_second = 50, -- how many lines/seconds to show
      trail_length = 20, -- how long the trail / fade transition should be

      -- other stuff
      max_lines = 1024, -- if the buffer exceeds this number of lines, anyline will be disabled
      priority = 19, -- extmark priority
      priority_context = 20,
      ft_ignore = {
        "NvimTree",
        "TelescopePrompt",
        "alpha",
        "vim",
        "hyprlang",
        "vimdoc",
      },
    }
  end,
}
