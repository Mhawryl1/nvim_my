return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "tomblind/local-lua-debugger-vscode",
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = { virt_text_pos = "eol", virt_text = true },
    },
  },
  config = function()
    local dap = require "dap"
    local get_icon = require("core.assets").getIcon
    require("nvim-dap-virtual-text").setup()

    ---C++ debuger adapters
    -- dap.adapters.cppdbg = {
    --   id = "cppdbg",
    --   type = "executable",
    --   command = vim.fn.stdpath "data" .. "/mason/bin/OpenDebugAD7", -- Path to the cppdbg executable from Mason
    -- }
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = "$MASON/packages/codelldb/extension/adapter/codelldb.exe",
      args = { "--port", "${port}" },
    }
    -- Configuration for MSVC Debugging
    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
      },
      {
        name = "Attach to gdbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
      },
    }
    dap.adapters["local-lua"] = {
      type = "executable",
      command = "node",
      args = {
        "/home/darol/.local/share/nvim_my/lazy/local-lua-debugger-vscode/extension/debugAdapter.js",
      },
      enrich_config = function(config, on_config)
        if not config["extensionPath"] then
          local c = vim.deepcopy(config)
          -- 💀 If this is missing or wrong you'll see
          -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
          c.extensionPath = "/home/darol/.local/share/nvim_my/lazy/local-lua-debugger-vscode/extension/"
          on_config(c)
        else
          on_config(config)
        end
      end,
    }
    dap.adapters.chrome = {
      type = "executable",
      command = "node",
      args = {
        "C:\\Users\\DaroL\\AppData\\Local\\nvim-data\\mason\\packages\\chrome-debug-adapter\\out\\src\\chromeDebug.js╯",
      },
    }

    dap.configurations.javascript = { -- change this to javascript if needed
      {
        name = "javascript",
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
      },
    }

    dap.configurations.typescript = { -- change to typescript if needed
      {
        name = "typescript",
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
      },
    }
    dap.configurations.lua = {
      {
        name = "Current file (local-lua-dbg, nlua)",
        type = "local-lua",
        request = "launch",
        cwd = "${workspaceFolder}",
        program = {
          lua = "nlua.lua",
          file = "${file}",
        },
        verbose = true,
        args = {},
      },
    }
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#CA000F", bg = "" })
    vim.api.nvim_set_hl(0, "DapBreakpointHit", { fg = "#00FF00", bg = "#3c3836" })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, bg = "#2e4d3d", fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d", ctermbg = "Green" })
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = get_icon("lsp", "LSPLoading3", 0), texthl = "DapBreakpoint", linehl = "", numhl = "1" }
    )
    vim.fn.sign_define(
      "DapBreakpointHit",
      { text = get_icon("lsp", "LSPLoading3", 0), texthl = "blue", linehl = "", numhl = "1" }
    )

    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "⚠️", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    -- vim.fn.sign_define(
    --   "DapBreakpointRejected",
    --   { text = "❌", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
    -- )
    vim.fn.sign_define("DapLogPoint", { text = "🔍", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = " ▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    local dapui = require "dapui"
    dapui.setup()
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    local maps = require("core.utils").maps

    maps.n["<F5>"] = { function() require("dap").continue() end, { desc = "Debugger: Start" } }
    maps.n["<S-F5>"] = { function() require("dap").terminate() end, { desc = "Terminate Session (S-F5)" } }
    maps.n["<F17>"] = { function() require("dap").terminate() end, { desc = "Debugger: Stop" } }
    maps.n["<F21>"] = {
      function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then require("dap").set_breakpoint(condition) end
        end)
      end,
      { desc = "Debugger: Conditional Breakpoint" },
    }
    maps.n["<F29>"] = { function() require("dap").restart_frame() end, { desc = "Debugger: Restart" } }
    maps.n["<F6>"] = { function() require("dap").pause() end, { desc = "Debugger: Pause" } }
    maps.n["<F9>"] = { function() require("dap").toggle_breakpoint() end, { desc = "Debugger: Toggle Breakpoint" } }
    maps.n["<F10>"] = { function() require("dap").step_over() end, { desc = "Debugger: Step Over" } }
    maps.n["<F11>"] = { function() require("dap").step_into() end, { desc = "Debugger: Step Into" } }
    maps.n["<F23>"] = { function() require("dap").step_out() end, { desc = "Debugger: Step Out" } }
    maps.n["<Leader>db"] = { function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint (F9)" } }
    maps.n["<Leader>dB"] = { function() require("dap").clear_breakpoints() end, { desc = "Clear Breakpoints" } }
    maps.n["<Leader>dc"] = { function() require("dap").continue() end, { desc = "Start/Continue (F5)" } }
    maps.n["<Leader>dC"] = {
      function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then require("dap").set_breakpoint(condition) end
        end)
      end,
      { desc = "Conditional Breakpoint (S-F9)" },
    }
    maps.n["<Leader>di"] = { function() require("dap").step_into() end, { desc = "Step Into (F11)" } }
    maps.n["<Leader>do"] = { function() require("dap").step_over() end, { desc = "Step Over (F10)" } }
    maps.n["<Leader>dO"] = { function() require("dap").step_out() end, { desc = "Step Out (S-F11)" } }
    maps.n["<Leader>dq"] = { function() require("dap").close() end, { desc = "Close Session" } }
    maps.n["<Leader>dQ"] = { function() require("dap").terminate() end, { desc = "Terminate Session (S-F5)" } }
    maps.n["<Leader>dp"] = { function() require("dap").pause() end, { desc = "Pause (F6)" } }
    maps.n["<Leader>dr"] = { function() require("dap").restart_frame() end, { desc = "Restart (C-F5)" } }
    maps.n["<Leader>dR"] = { function() require("dap").repl.toggle() end, { desc = "Toggle REPL" } }
    maps.n["<Leader>ds"] = { function() require("dap").run_to_cursor() end, { desc = "Run To Cursor" } }
    vim.keymap.set("n", "<leader>ud", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
  end,
}
