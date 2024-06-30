return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.diagnostics.tflint,
			},
		})
		vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, { desc = "format buffer" })
	end,
}
