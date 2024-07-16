local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  { import = "core.plugins" },
  { import = "plugins" },
  { "catppuccin/nvim",      as = "catppuccin" },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "BufEnter",
    init = function()
      vim.cmd [[
      let g:VM_maps = {}
      let g:VM_maps['Find Under'] = ''
      ]]
      vim.keymap.set(
        "n",
        "<m-N>",
        "<cmd>call vm#commands#find_under(0, v:count1)<cr>",
        { noremap = false, desc = "[Visual-multi] find under cursor" }
      )
      vim.keymap.set(
        { "n" },
        "<m-K>",
        ":call vm#commands#add_cursor_up(0, v:count1)<cr>",
        { noremap = true, silent = true, desc = "[Visual-multi] add cursor above" }
      )
      vim.keymap.set(
        { "n" },
        "<m-J>",
        ":call vm#commands#add_cursor_down(0, v:count1)<cr>",
        { noremap = true, silent = true, desc = "[Visual-multi] add cursor below" }
      )
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      italic = {
        strings = true,
        comments = true,
        folds = true,
        operations = false,
      },
    },
    config = function() vim.cmd [[colorscheme gruvbox]] end,
  },
  {
    "folke/zen-mode.nvim",
    opts = {},
  },
  {
    "tpope/vim-surround",
    event = "BufEnter",
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
}
