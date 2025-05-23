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
    hooks = {
      yazi_opened = function(preselected_path, yazi_buffer_id, config)
        -- you can optionally modify the config for this specific yazi
        -- invocation if you want to customize the behaviour
        vim.api.nvim_del_keymap("t", "jk")
      end,

      -- when yazi was successfully closed
      yazi_closed_successfully = function(chosen_file, config, state)
        -- you can optionally modify the config for this specific yazi
        -- invocation if you want to customize the behaviour
        vim.api.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true })
      end,
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
