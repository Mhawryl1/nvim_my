local getIcon = require("core.assets").getIcon
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    -- check the installation instructions at
    -- https://github.com/folke/snacks.nvim
    "folke/snacks.nvim",
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>ty",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = getIcon("ui", "Files") .. " Open yazi at the current file",
    },
    {
      -- Open in the current working directory
      "<leader>td",
      "<cmd>Yazi cwd<cr>",
      desc = getIcon("ui", "Files") .. " Open the file manager in nvim's working directory",
    },
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = getIcon("ui", "Files") .. " Resume the last yazi session",
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
