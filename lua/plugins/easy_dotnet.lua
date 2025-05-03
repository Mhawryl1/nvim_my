if true then return {} end
return {
  "GustavEikaas/easy-dotnet.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function() require("easy-dotnet").setup() end,
}
