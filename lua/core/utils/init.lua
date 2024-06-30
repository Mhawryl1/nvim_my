local M = {}
function M.get_buf_option(opt)
	local bufnr = vim.api.nvim_get_current_buf()
	local buf_option = vim.api.nwim_get_option_value(opt, { buf = bufnr })
	if not buf_option then
		return nil
	else
		return buf_option
	end
end

function M.is_empty(s)
	return s == nil or s == ""
end

local function getIcons()
	local __devicons
	if not __devicons then
		local ok, devicons = pcall(require, "nvim-web-devicons")
		__devicons = ok and devicons.get_icons() or {}
	end
	return __devicons
end

function M.activeLsp()
	local devicon
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if next(clients) ~= nil then
		for _, client in pairs(clients) do
			if client.name ~= "null-ls" then
				local fts = client.config.filetypes or { vim.bo.filetype }
				local icons = getIcons()
				table.insert(fts, vim.fn.expand("%:e"))
				for _, ft in pairs(fts) do
					if icons[ft] then
						devicon = icons[ft]
						local icon = { devicon.icon }
						icon.color = { fg = devicon.color }
						return { name = client.name, icon = icon }
					end
				end
				return { name = client.name, icon = nil }
			end
		end
	end
end

local function activeNullLsConf()
	local buf_ft = vim.bo.filetype
	local null_ls_s, null_ls = pcall(require, "null-ls")
	local ret_str = ""
	if null_ls_s then
		local sources = null_ls.get_sources()
		for _, source in ipairs(sources) do
			if source._validated then
				for ft_name, ft_active in pairs(source.filetypes) do
					if ft_name == buf_ft and ft_active then
						ret_str = ret_str .. source.name
					end
				end
			end
		end
	end
	return ret_str
end

local function getLinter()
	local buf_ft = vim.bo.filetype
	local ok, lint = pcall(require, "lint")
	local ret_str = ""
	if ok then
		for ft_k, ft_v in pairs(lint.linters_by_ft) do
			if type(ft_v) == "table" then
				for _, linter in pairs(ft_v) do
					if buf_ft == ft_k then
						ret_str = ret_str .. linter
					end
				end
			elseif type(ft_v) == "string" then
				if buf_ft == ft_k then
					ret_str = ret_str .. ft_v
				end
			end
		end
	end
	return ret_str
end

function M.getLsp()
	local hl = vim.api.nvim_get_hl(0, { name = "lualine_a_normal" })
	local client = require("core.utils").activeLsp()
	vim.api.nvim_set_hl(0, "LspIcon", { fg = client.icon.color.fg })
	if vim.g.toggleFormating then
		vim.api.nvim_set_hl(0, "FormatStatus", { fg = "#c1d00a" })
	else
		vim.api.nvim_set_hl(0, "FormatStatus", { fg = "#ff0000" })
	end
	return string.format(
		"%%#LspIcon#%s %%#MyStatusName#%s | %%#FormatStatus#%s  %%#MyStatusName#%s",
		client.icon[1],
		client.name,
		activeNullLsConf(),
		getLinter()
	)
end

function M.currentDir()
	local hl = vim.api.nvim_get_hl(0, { name = "lualine_a_normal" })
	local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
	local cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
	cwd = vim.fn.fnamemodify(cwd, ":~")
	if #cwd > 40 then
		cwd = vim.fn.pathshorten(cwd)
	end
	local trail = cwd:sub(-1) == "/" and "" or "/"
	vim.api.nvim_set_hl(0, "StatusIcon", { fg = hl.bg })
	return string.format("%%#StatusIcon#%s %%#MyStatusName#%s%%#MyStatusName#%s", icon, cwd, trail)
end

function M.spellcheck()
	local icon = " "
	if vim.wo.spell then
		local hl = vim.api.nvim_get_hl(0, { name = "lualine_a_normal" })
		vim.api.nvim_set_hl(0, "SpellIcon", { fg = hl.bg })
		return string.format("%%#SpellIcon#%s %%#MyStatusName#%s", icon, vim.o.spelllang)
	end
	vim.api.nvim_set_hl(0, "SpellIcon", { fg = "#ff0000" })
	return string.format("%%#SpellIcon#%s %%#MyStatusName#%s", icon, vim.o.spelllang)
end

local function map(mode, lhs, rhs, opts)
	local options = { silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

local function closeCurr(bufnr)
	vim.cmd("bprev")
	vim.cmd("bdelete!" .. bufnr)
end
function M.close_buffer()
	local bufnr = vim.api.nvim_get_current_buf()
	local buf_windows = vim.call("win_findbuf", bufnr)
	local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
	local bufname = vim.fn.expand("%")
	if buf_windows.empyt then
		bufname = "Untitled"
	end

	if modified and #buf_windows == 1 then
		local confirm = vim.fn.confirm(('Save changes to "%s"?'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
		if confirm == 1 then
			if buf_windows.empty then
				return
			end
			vim.cmd.write()
			closeCurr(bufnr)
		elseif confirm == 2 then
			closeCurr(bufnr)
		else
			return
		end
	else
		closeCurr(bufnr)
	end
end

M.maps = { n = {}, v = {} }
local metatable = {
	__newindex = function(table, key, value)
		if table == M.maps.n then
			map("n", key, value[1], value[2])
		elseif table == M.maps.v then
			map("v", key, value[1], value[2])
		else
			vim.notify("Key mode don't exist", vim.log.levels.ERROR)
		end
		rawset(table, key, value)
	end,
}

setmetatable(M.maps.n, metatable)
setmetatable(M.maps.v, metatable)
return M
