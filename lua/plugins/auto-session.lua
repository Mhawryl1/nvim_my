return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")
    local maps = require("core.utils").maps
    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    maps.n["<leader>Ss"] = { "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" } } -- save workspace session for current working directory }
  end,
}
