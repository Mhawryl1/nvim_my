return {
  "ray-x/lsp_signature.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    require("lsp_signature").setup(opts)
  end,
  conf = {
    bind = true,
    handler_opts = {
      border = "rounded",
    },
    hint_enable = true,
    hint_prefix = " ",
    hint_scheme = "String",
    hi_parameter = "LspSignatureActiveParameter",
    select_signature_key = "<M-x>",
    scrollable = true,
  },
  vim.keymap.set({ "n", "s" }, "<C-k>", function()
    vim.lsp.buf.select_signature_key()
  end, { buffer = 0, desc = "LSP Select next signature" }),
  vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = "#fabd2f", fg = "#0c1030" }),
}
