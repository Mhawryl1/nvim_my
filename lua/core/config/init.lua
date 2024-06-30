local M = {}

function M.getIcon(grup, kind, padding)
	local icon = assert(require("core.config.icons")[grup][kind], "Icon not found!")
	padding = padding or 0
	return icon .. string.rep(" ", padding)
end

return M
