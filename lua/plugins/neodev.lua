return {
  "folke/neodev.nvim",
  opts = {},
  config = function()
    require("neodev").setup({
      library = { plugins = { "nvim-dap-ui" }, types = true }, -- your configuration comes here
    })
  end,
}
