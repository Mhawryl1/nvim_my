if true then return {} end
return {
  "zbirenbaum/copilot-cmp",
  event = { "InsertEnter", "LspAttach" },
  fix_pairs = true,
  config = function()
    local lspkind = require "lspkind"
    lspkind.init {
      symbol_map = {
        Copilot = "",
      },
    }

    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    require("copilot_cmp").setup()
  end,
}
