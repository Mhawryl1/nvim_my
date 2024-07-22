return {
  "chentoast/marks.nvim",
  event = "BufEnter",
  config = function()
    require("marks").setup {
      default_mappings = true,                                                -- Use default key mappings
      builtin_marks = { ".", "<", ">", "^" },                                 -- List of built-in marks to search for
      cyclic = true,                                                          -- When set to true, cycle through marks when calling next/prev
      force_write_shada = false,                                              -- Write shada on the change of marks or deletion
      refresh_interval = 250,                                                 -- How often (in ms) to refresh signs
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 }, -- Priority of signs
      excluded_filetypes = {},                                                -- A list of filetypes that will be excluded
      bookmark_0 = {
        sign = "⚑",
        virt_text = "               ⚑ Bookmark",
      },
      mappings = {},
    }
  end,
}
