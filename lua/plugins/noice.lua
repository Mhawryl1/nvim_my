--iftruethenreturn{}end
return {
	"folke/noice.nvim",
	dependencies = {
		--ifyoulazy-loadanypluginbelow,makesuretoaddproper`module="..."`entries
		"MunifTanjim/nui.nvim",
		--OPTIONAL:
		--`nvim-notify`isonlyneeded,ifyouwanttousethenotificationview.
		--Ifnotavailable,weuse`mini`asthefallback
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L,%d+B" },
							{ find = ";after#%d+" },
							{ find = ";before#%d+" },
							{ find = "%dfewerlines" },
							{ find = "%dmorelines" },
						},
					},
					opts = { skip = true },
				},
			},
		})
	end,
}
