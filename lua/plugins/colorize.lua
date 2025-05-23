return {
  "norcalli/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    require("colorizer").setup {
      "*", -- Highlight all files, but customize some others.
      css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
      html = { names = true, rgb_fn = true }, -- Disable parsing "names" like Blue or Gray
      lua = { name = true, rgb_fn = true },
    }
  end,
}
