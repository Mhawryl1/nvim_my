return {

	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	event = "UIEnter",
	config = function()
		local bufferline = require("bufferline")
		local map = require("core.utils").map

		-- Go to nth buffer keymaps
		for n = 1, 9 do
			map("n", "g" .. n, function()
				bufferline.go_to_buffer(n, true)
			end, { desc = "[Bufferline] Go to " .. n .. "th buffer" })
		end
		bufferline.setup({
			highlights = {
				buffer_selected = {
					bold = false,
					italic = true,
					fg = "#ffa000",
				},
				indicator_selected = {
					fg = "#f24f72",
					bg = "bg",
				},
			},

			options = {
				buffer_close_icon = "",
				custom_filter = function(buf)
					return vim.bo[buf].filetype ~= "qf"
				end,
				diagnostics = false,
				hover = {
					enabled = true,
					delay = 100,
					reveal = { "close" },
				},
				indicator = {
					icon = "▎",
					style = "icon",
					h1 = "BufferlineIndicator",
				},
				max_name_length = 50,
				numbers = function(opts)
					return string.format("%s", opts.raise(opts.ordinal))
				end,
				modified_icon = "",
				offsets = {
					{
						filetype = "NvimTree",
						text = function()
							return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						end,
						text_align = "center",
					},
				},
			},
		})
	end,
}
