return {
  "ThePrimeagen/harpoon",
  event = "BufWinEnter",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    require("telescope").load_extension "harpoon"
    require("harpoon").setup {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      global_settings = {
        -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
        save_on_toggle = false,

        -- saves the harpoon file upon every change. disabling is unrecommended.
        save_on_change = true,

        -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
        enter_on_sendcmd = false,

        -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
        tmux_autoclose_windows = false,

        -- filetypes that you want to prevent from adding to the harpoon list menu.
        excluded_filetypes = { "harpoon" },

        -- set marks specific to each git branch inside git repository
        mark_branch = false,

        -- enable tabline with harpoon marks
        tabline = false,
        tabline_prefix = "   ",
        tabline_suffix = "   ",
      },
    }

    vim.api.nvim_set_keymap(
      "n",
      "<leader>ht",
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      { noremap = true, silent = true, desc = "Toggle Harpoon UI" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>ha",
      "<cmd>lua require('harpoon.mark').add_file()<cr>",
      { noremap = true, silent = true, desc = "Add file" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hh",
      "<cmd>lua require('harpoon.ui').nav_file(1)<cr>",
      { noremap = true, silent = true, desc = "Got to buffer 1" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hj",
      "<cmd>lua require('harpoon.ui').nav_file(2)<cr>",
      { noremap = true, silent = true, desc = "Got to buffer 2" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hk",
      "<cmd>lua require('harpoon.ui').nav_file(3)<cr>",
      { noremap = true, silent = true, desc = "Got to buffer 3" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hl",
      "<cmd>lua require('harpoon.ui').nav_file(4)<cr>",
      { noremap = true, silent = true, desc = "Got to buffer 4" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hn",
      "<cmd>lua require('harpoon.ui').nav_next()<cr>",
      { noremap = true, silent = true, desc = "Select next buffer" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hp",
      "<cmd>lua require('harpoon.ui').nav_prev()<cr>",
      { noremap = true, silent = true, desc = "Select prev buffer" }
    )
    for i = 1, 5 do
      vim.api.nvim_set_keymap(
        "n",
        "#" .. i,
        "<cmd>lua require('harpoon.ui').nav_file(" .. i .. ")<cr>",
        { noremap = true, silent = true, desc = "select " .. i .. " buffer from list" }
      )
    end
  end,
}
