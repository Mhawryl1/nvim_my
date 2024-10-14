return {
  "mfussenegger/nvim-lint",
  config = function()
    local _args = { "--log-level=warning" }
    if vim.fn.has "win32" == 1 then table.insert(_args, "--line-ending=windows") end
    local function cmake_lint_parser(output, bufnr)
      local diagnostics = {}

      local function get_severity(code)
        if code:match "^E" then
          return vim.diagnostic.severity.ERROR
        elseif code:match "^C" then
          return vim.diagnostic.severity.INFO
        else
          return vim.diagnostic.severity.WARN
        end
      end

      for _, line in ipairs(vim.split(output, "\n")) do
        local filename, lnum, col, code, message = line:match "([^:]+):(%d+),(%d+): %[(%w+)%] (.+)"

        if not filename then
          filename, lnum, code, message = line:match "([^:]+):(%d+): %[(%w+)%] (.+)"
          col = nil
        end

        if filename and lnum and code and message then
          table.insert(diagnostics, {
            lnum = tonumber(lnum) - 1,
            col = col and (tonumber(col) - 1) or 0, -- If no column, set it to 0
            message = "[" .. code .. "] " .. message,
            severity = get_severity(code),
            bufnr = bufnr,
          })
        end
      end

      return diagnostics
    end
    require("lint").linters.cmake_lint = {
      cmd = "cmake-lint",
      stdin = false,
      append_fname = true,
      ignore_exitcode = true,
      args = _args,
      stream = "stdout",
      parser = cmake_lint_parser,
    }
    require("lint").linters_by_ft = {
      javascript = { "biomejs" },
      typescript = { "biomejs" },
      lua = { "selene" },
      cmake = { "cmake_lint" },
    }
  end,
}
