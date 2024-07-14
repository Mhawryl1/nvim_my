return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  event = "BufRead",
  config = function()
    local get_icon = require("core.assets").getIcon
    vim.api.nvim_set_keymap(
      "n",
      "<leader>bu",
      "<cmd>UndotreeToggle<cr>",
      { noremap = true, silent = true, desc = get_icon("ui", "Undo", 1) .. "Toggle undotree" }
    )
  end,
}
