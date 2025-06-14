if true then return {} end
return {
  "ray-x/lsp_signature.nvim",
  event = "BufEnter",
  opts = {},
  config = function(_, opts) require("lsp_signature").setup(opts) end,
  conf = {
    bind = true,
    handler_opts = {
      border = "rounded",
    },
    hint_enable = true,
    toggle_key = "<C-s>",
    hint_prefix = "🐼 ",
    hi_parameter = "LspSignatureActiveParameter",
    hint_scheme = "String",
    select_signature_key = "<M-n>",
    zindex = 200,
    scrollable = true,
    floating_window_above_cur_line = true,
  },
  -- vim.keymap.set("i", "<C-k>", function()
  --   vim.lsp.buf.select_signature_key()
  -- end, { buffer = 0, desc = "LSP Select next signature" }),
  vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = "#fabd2f", fg = "#0c1030" }),
}
