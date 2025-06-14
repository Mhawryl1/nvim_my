return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  event = "VeryLazy",
  opts = {
    input = {
      relative = "editor",
    },
    bigfile = { enabled = true },
    image = { enabled = true },
    explorer = { enabled = false },
    indent = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    scope = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
    rename = { enabled = false },
  },
}
