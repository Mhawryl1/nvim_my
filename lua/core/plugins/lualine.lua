return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"dokwork/lualine-ex",
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lualine = require("lualine")
		local utils = require("core.utils")
		local navic = require("nvim-navic")

		local config = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = " ", right = "" },
				section_separators = { left = " ", right = " " },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{ "ex.git.branch", icon = "", disabled_icon_color = { fg = "grey" } },
					"diff",
					"diagnostics",
				},
				lualine_c = {
					"filetype",
					utils.currentDir,
				},
				lualine_x = {
					{ utils.spellcheck },
					"encoding",
					"fileformat",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {
				lualine_c = {
					{
						function()
							return navic.get_location()
						end,
						cond = function()
							return navic.is_available()
						end,
					},
				},
			},
			inactive_winbar = {},
			extensions = { "quickfix", "neo-tree" },
		}
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x ot right section
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end
		local custom_spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		-- ins_left({
		--   "lsp_progress",
		--   display_components = { "spinner", { "percentage", "title" }, "lsp_client_name" },
		--   timer = { progress_enddelay = 1000, spinner = 1000, lsp_client_name_enddelay = 1000 },
		--   colors = {
		--     percentage = colors.cyan,
		--     title = colors.cyan,
		--     message = colors.cyan,
		--     spinner = colors.cyan,
		--     lsp_client_name = colors.magenta,
		--     use = true,
		--   },
		--   separators = {
		--     component = " ",
		--     progress = " | ",
		--     percentage = { pre = "", post = "%% " },
		--     title = { pre = "", post = ": " },
		--     lsp_client_name = { pre = " ", post = " " },
		--     spinner = { pre = "", post = "" },
		--   },
		--   spinner_symbols = custom_spinner,
		-- })
		lualine.setup(config)
	end,
}
