local M = {}

local getIcon = require("core.assets").getIcon
function M.get_buf_option(opt)
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_option = vim.api.nwim_get_option_value(opt, { buf = bufnr })
  if not buf_option then
    return nil
  else
    return buf_option
  end
end

function M.is_empty(s) return s == nil or s == "" end

local function getIcons()
  local __devicons
  if not __devicons then
    local ok, devicons = pcall(require, "nvim-web-devicons")
    __devicons = ok and devicons.get_icons() or {}
  end
  return __devicons
end

function M.activeLsp()
  local devicon = nil
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if next(clients) ~= nil then
    for _, client in pairs(clients) do
      if client.name ~= "null-ls" then
        local fts = client.config.filetypes or { vim.bo.filetype }
        local icons = getIcons()
        table.insert(fts, vim.fn.expand "%:e")
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
          if ft_name == buf_ft and ft_active then ret_str = ret_str .. source.name end
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
          if buf_ft == ft_k then ret_str = ret_str .. linter end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then ret_str = ret_str .. ft_v end
      end
    end
  end
  return ret_str
end
require "core.assets.colors"
function M.getLsp()
  local client = M.activeLsp()
  vim.api.nvim_set_hl(0, "LspIcon", { fg = client.icon.color.fg })
  if vim.g.toggleFormating then
    vim.api.nvim_set_hl(0, "FormatStatus", { fg = "#c1d00a" })
  else
    vim.api.nvim_set_hl(0, "FormatStatus", { fg = "#ff0000" })
  end
  return string.format(
    "%%#LspIcon#%s %%#MyStatusName#%s | %%#FormatStatus#%s  %%#MyStatusName#%s",
    client.icon[1] or "",
    client.name or "",
    activeNullLsConf(),
    getLinter()
  )
end

function M.getHLColor()
  local mode = vim.api.nvim_get_mode().mode
  local hl = nil
  if mode == "v" or mode == "V" then
    hl = vim.api.nvim_get_hl(0, { name = "lualine_c_visual" })
  elseif mode == "c" then
    hl = vim.api.nvim_get_hl(0, { name = "lualine_c_command" })
  elseif mode == "i" then
    hl = vim.api.nvim_get_hl(0, { name = "lualine_c_insert" })
  elseif mode == "R" then
    hl = vim.api.nvim_get_hl(0, { name = "lualine_c_replace" })
  else
    hl = vim.api.nvim_get_hl(0, { name = "lualine_c_normal" })
  end
  if next(hl) == nil then return vim.api.nvim_get_hl(0, { name = "lualine_c_normal" }) end
  return hl
end

function M.currentDir()
  local hl = M.getHLColor()
  vim.api.nvim_set_hl(0, "DirectoryPath", { fg = hl.fg, bg = hl.bg })
  local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
  local cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  cwd = vim.fn.fnamemodify(cwd, ":~")
  if #cwd > 40 then cwd = vim.fn.pathshorten(cwd) end
  local trail = cwd:sub(-1) == "/" and "" or "/"
  vim.api.nvim_set_hl(0, "StatusIcon", { fg = "#51a0cf", bg = hl.bg })
  return string.format("%%#StatusIcon#%s %%#DirectoryPath#%s%%#DirectoryPath#%s", icon, cwd, trail)
end

function M.spellcheck()
  local icon = " "
  local hl_group = M.getHLColor()
  vim.api.nvim_set_hl(0, "SpellIconDef", { fg = hl_group.fg, bg = hl_group.bg })
  if not vim.wo.spell then
    vim.api.nvim_set_hl(0, "SpellIcon", { fg = "#FF0000", bg = hl_group.bg })
    return string.format("%%#SpellIcon#%s %%#SpellIconDef#%s", icon, vim.o.spelllang)
  end
  vim.api.nvim_set_hl(0, "SpellIcon", { fg = "#51a0cf", bg = hl_group.bg })
  return string.format("%%#SpellIcon#%s %%#SpellIconDef#%s", icon, vim.o.spelllang)
end

local function map(mode, lhs, rhs, opts)
  local options = { silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function closeCurr(bufnr)
  vim.cmd "bprev"
  vim.cmd("bdelete!" .. bufnr)
end

function M.close_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call("win_findbuf", bufnr)
  local modified = vim.api.nvim_get_option_value("modified", { buf = bufnr })
  local bufname = vim.fn.expand "%"
  if buf_windows.empyt then bufname = "Untitled" end

  if modified and #buf_windows == 1 then
    local confirm = vim.fn.confirm(('Save changes to "%s"?'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
    if confirm == 1 then
      if buf_windows.empty then return end
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

function M.get_plugin(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.assets")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] or nil
end

function M.is_available(plugin) return M.get_plugin(plugin) ~= nil end

M.maps = { n = {}, v = {}, i = {} }
local metatable = {
  __newindex = function(table, key, value)
    if table == M.maps.n then
      map("n", key, value[1], value[2])
    elseif table == M.maps.v then
      map("v", key, value[1], value[2])
    elseif table == M.maps.i then
      map({ "i", "s" }, key, value[1], value[2])
    else
      vim.notify("Key mode don't exist", vim.log.levels.ERROR)
    end
    rawset(table, key, value)
  end,
}

setmetatable(M.maps.n, metatable)
setmetatable(M.maps.v, metatable)

--------------==============---------------------
function M.macro_recording()
  local recording_register = vim.fn.reg_recording()
  local hl = vim.api.nvim_get_hl(0, { name = "lualine_c_normal" })
  vim.api.nvim_set_hl(0, "RecordingIcon", { fg = "#FF0809", bg = hl.bg })
  vim.api.nvim_set_hl(0, "RecordingDefault", { fg = hl.fg, bg = hl.bg })
  if recording_register == "" then
    return ""
  else
    return string.format("%%#RecordingIcon#%s %%#RecordingDefault#%s", "󰑋", "Recording @") .. recording_register
  end
end

local function containsFt(ft, ft_list)
  ft = ft or vim.bo.filetype
  if ft_list[ft] == true then return true end
  return false
end

local function getNullLsClients(active_sources)
  local null_ls_s, null_ls = pcall(require, "null-ls")
  if null_ls_s == false then return end
  local sources = null_ls.get_sources()
  local ft = vim.bo.filetype
  for _, source in ipairs(sources) do
    if containsFt(ft, source.filetypes) then
      if source.methods["NULL_LS_RANGE_FORMATTING"] == true then
        active_sources.formatters = { source.name }
      elseif source.methods["NULL_LS_DIAGNOSTICS"] == true then
        active_sources.linters = { source.name }
      else
        active_sources.others = { source.name }
      end
    end
  end
end

-- Function to determine if a client is an LSP server
local function is_lang_lsp_prov(client)
  -- Explicitly exclude GitHub Copilot
  if client.name == "copilot" then return false end
  if client._log_prefix:find "^LSP" then
    return true
  else
    local lsp_capabilities = {
      "hoverProvider",
      "referencesProvider",
    }
    for _, capability in ipairs(lsp_capabilities) do
      if client.server_capabilities[capability] == true then return true end
    end
    return false
  end
end

local function getFromatterFromConform()
  local ok, conform = pcall(require, "conform")
  if not ok then return nil end
  return conform.list_formatters_for_buffer()[1]
end

-- get clients and categorize them
local function get_clients()
  local categorized_clients = {
    lsp_servers = {},
    formatters = {},
    linters = {},
    others = {},
  }
  local devicon = nil
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if not vim.tbl_isempty(clients) then
    for _, client in pairs(clients) do
      if client.name == "null-ls" then
        getNullLsClients(categorized_clients)
      elseif is_lang_lsp_prov(client) then
        local ft = vim.bo.filetype
        local icons = getIcons()

        if ft == "javascript" then
          ft = "js"
        elseif ft == "typescript" then
          ft = "ts"
        end
        if icons[ft] then
          devicon = icons[ft]
          local icon = { icon = devicon.icon }
          icon.color = { fg = devicon.color }
          categorized_clients = vim.tbl_extend("force", categorized_clients, { lsp_servers = { client.name, icon } })
        else
          categorized_clients = vim.tbl_extend("force", categorized_clients, { lsp_servers = { client.name } })
        end
      else
        categorized_clients = vim.tbl_extend("force", categorized_clients, { others = { client.name } })
      end
    end
  end
  if #categorized_clients.formatters == 0 and require "conform" then
    categorized_clients.formatters = { getFromatterFromConform() }
  end
  return categorized_clients
end

function M.lspSection()
  local retTable = {}
  local separator = " | "
  local clients = get_clients()
  local hl_group = M.getHLColor()
  if hl_group.bg == nil then return "" end
  local bg_color = string.format("#%06x", hl_group.bg)
  vim.api.nvim_set_hl(0, "CustomLine", { fg = hl_group.fg, bg = bg_color })
  if vim.g.toggleFormating then
    vim.api.nvim_set_hl(0, "FormatStatus", { fg = "#c1d00a", bg = bg_color })
  else
    vim.api.nvim_set_hl(0, "FormatStatus", { fg = "#ff0000", bg = bg_color })
  end
  for key, client in pairs(clients) do
    if key == "lsp_servers" and client[1] ~= nil then
      vim.api.nvim_set_hl(0, "LspIcon", { fg = client[2] ~= nil and client[2].color.fg or "", bg = bg_color })
      table.insert(
        retTable,
        1,
        string.format("%%#LspIcon#%s  %s", client[2] ~= nil and client[2].icon or "", client[1])
      )
    elseif key == "formatters" and client[1] ~= nil then
      table.insert(retTable, 2, string.format("%%#FormatStatus#%s", client[1]))
    elseif key == "linters" and client[1] ~= nil then
      table.insert(retTable, 3, string.format("%%#CustomLine#%s", client[1]))
    elseif key == "others" and client[1] ~= nil then
      table.insert(retTable, 4, string.format("%%#CustomLine#%s", client[1]))
    end
  end
  local ret_str = ""

  for _, value in pairs(retTable) do
    ret_str = ret_str .. value .. separator
  end
  return string.sub(ret_str, 1, #ret_str - 2)
end

function M.rename_file(opts)
  local new_name = opts.args
  local curr_file_name = vim.fn.expand "%:t"
  if curr_file_name == new_name then return end
  local status, _ = pcall(vim.api.nvim_command, ":saveas " .. new_name)
  if not status then
    local confirm = vim.fn.confirm("File already exists. Overwrite?", "&Yes\n&No", 1, "Question")
    if confirm == 1 then
      vim.api.nvim_command(":saveas! " .. new_name)
      vim.api.nvim_command(":bdelete " .. curr_file_name)
      vim.fn.system("rm " .. curr_file_name)
      return
    end
  end
  vim.api.nvim_command(":bdelete " .. curr_file_name)
  vim.fn.system("rm " .. curr_file_name)
end

function M.delete_file(opts)
  local curr_file_name = nil
  if opts.args == "" then
    curr_file_name = vim.fn.expand "%:p"
  else
    curr_file_name = vim.fn.expand(opts.args)
  end

  local confirm = vim.fn.confirm("Delete this " .. curr_file_name .. " file?", "&Yes\n&No", 1, "Question")
  if confirm == 1 then
    local _, _ = pcall(vim.api.nvim_command, ":bdelete " .. curr_file_name)
    local result = vim.fn.system("rm " .. curr_file_name)
    if vim.v.shell_error ~= 0 then
      vim.notify(result, vim.log.levels.WARN, { title = "Delete file" })
      return
    end
    vim.notify("File " .. curr_file_name .. " successfully deleted.", vim.log.levels.INFO, { title = "Delete file" })
  end
end

local function custom_input(opts, on_confirm)
  local bufnr = vim.api.nvim_create_buf(false, true)
  local width = opts.width or 30
  local height = 1
  local row = opts.row or math.floor((vim.o.lines - height) / 2)
  local col = opts.col or math.floor((vim.o.columns - width) / 2)

  vim.o.termguicolors = true
  vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    zindex = 100,
    col = col,
    style = "minimal",
    border = {
      { "╭", "NotifyDEBUGTitle" },
      { "─", "NotifyDEBUGTitle" },
      { "╮", "NotifyDEBUGTitle" },
      { "│", "NotifyDEBUGTitle" },
      { "╯", "NotifyDEBUGTitle" },
      { "─", "NotifyDEBUGTitle" },
      { "╰", "NotifyDEBUGTitle" },
      { "│", "NotifyDEBUGTitle" },
    },
    title = opts.title or "Input",
    title_pos = "center",
    noautocmd = false,
  })
  vim.api.nvim_set_option_value("buftype", "prompt", { buf = bufnr })
  vim.api.nvim_buf_add_highlight(bufnr, 0, "Inputprompt", row, col, #opts.prompt)
  vim.fn.prompt_setprompt(bufnr, opts.prompt or " ")
  vim.api.nvim_set_hl(0, "Inputprompt", { fg = "#51a0cf", bg = "#1e1e1e" })
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "i",
    "<Esc>",
    "<cmd>lua vim.api.nvim_win_close(0, true)<cr> <cmd>lua vim.api.nvim_buf_delete("
      .. bufnr
      .. ", {force = true })<CR>",
    { noremap = true, silent = true }
  )

  vim.fn.prompt_setcallback(bufnr, function(input)
    vim.api.nvim_win_close(0, true)
    on_confirm(input)
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end)
  vim.cmd "startinsert!"
end

local function save_as()
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  custom_input({
    prompt = string.format("%s", "    "),
    title = { { " Save as:", "FloatTitle" } },
    width = 50,
    completion = "file",
  }, function(input)
    if not input or input == "" then return end
    local new_file = vim.fs.basename(input)
    local directory = vim.fs.dirname(input)
    if vim.fn.isdirectory(directory) == 0 then vim.fn.mkdir(directory, "p") end

    if vim.fn.filereadable(input) == 1 then
      local confirm = vim.fn.confirm("File already exists. Overwrite?", "&Yes\n&No", 1, "Question")
      if confirm == 1 then
        vim.fn.delete(input)
      else
        return
      end
    end

    local err, file = pcall(io.open, input, "w")
    if file then
      for _, line in ipairs(content) do
        file:write(line .. "\n")
      end
      file:close()
      vim.notify("File saved as: " .. new_file, vim.log.levels.INFO, { title = "Save as" })
    else
      vim.notify("Failed to save file: " .. new_file .. " Error: " .. err, vim.log.levels.ERROR, { title = "Save as" })
    end
  end)
end

-- Add a command to call the save_as function
vim.api.nvim_create_user_command("SaveAs", save_as, {})
-- vim.api.nvim_create_user_command("SaveAs", save_as, {})

--check if current project is a git repo
function M.is_git_repo()
  local err, stout = pcall(vim.fn.system, "git rev-parse --is-inside-work-tree")
  if err then
    if string.match(stout, "fatal") then return false end
    return true
  end
  return false
end

return M
