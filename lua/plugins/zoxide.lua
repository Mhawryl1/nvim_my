--if true then return {} end
return {
    "jvgrootveld/telescope-zoxide",
  dependencies = {
     "nvim-telescope/telescope.nvim",
  },
  config = function() require("telescope").load_extension "zoxide" end,
}
