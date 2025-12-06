return {
  "brianhuster/live-preview.nvim",
  dependencies = {
    -- You can choose one of the following pickers
    "nvim-telescope/telescope.nvim",
    "ibhagwan/fzf-lua",
    "echasnovski/mini.pick",
    "folke/snacks.nvim",
  },
  config = {
    port = 8080, -- Port to use for the live preview server
  },
}
