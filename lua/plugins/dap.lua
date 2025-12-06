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
    local mason_path = vim.fn.stdpath "data" .. "/mason/"
    local mason_ext_path = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/"

    dap.adapters.codelldb = {
      type = "server",
      host = "127.0.0.1",
      port = "${port}",
      --executable = { command = "/usr/bin/lldb-dap", args = { "--port", "${port}" } },
      executable = { command = vim.fn.expand(mason_ext_path .. "adapter/codelldb"), args = { "--port", "${port}" } },
    }
    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
      },
      {
        name = "Attach to gdbserver :1234",
        type = "codelldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        name = "Launch with args",
        type = "codelldb",
        request = "launch",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
          local input = vim.fn.input "Program arguments: "
          return vim.fn.split(input, " ", true)
        end,
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
    dap.adapters.firefox = {
      type = "executable",
      command = "node",
      args = {
        mason_path .. "/packages/firefox-debug-adapter/dist/adapter.bundle.js",
      },
    }

    dap.adapters.chrome = {
      type = "executable",
      command = "node",
      args = {
        mason_path .. "/packages/chrome-debug-adapter/out/src/chromeDebug.js",
      },
    }
    dap.configurations.javascript = {
      {
        name = "Debug with Firefox - Attach",
        type = "firefox",
        request = "launch",
        reAttach = true,
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
        firefoxExecutable = "/usr/bin/firefox",
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
    dap.adapters.netcoredbg = {
      type = "executable",
      command = mason_path .. "/packages/netcoredbg/netcoredbg/netcoredbg",
      args = { "--interpreter=vscode" },
      detach = false,
    }
    dap.configurations.cs = {
      {
        type = "netcoredbg",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          -- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/src/", "file")
          return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net8.0/", "file")
        end,
        console = "internalConsole",
      },
    }
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#CA000F", bg = "" })
    vim.api.nvim_set_hl(0, "DapBreakpointHit", { fg = "#00FF00", bg = "#3c3836" })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, bg = "#2e4d3d", fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d", ctermbg = "Green" })
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = get_icon("lsp", "LSPLoading2", 0) .. " ", texthl = "DapBreakpoint", linehl = "", numhl = "1" }
    )
    vim.fn.sign_define(
      "DapBreakpointHit",
      { text = get_icon("lsp", "LSPLoading2", 0) .. " ", texthl = "blue", linehl = "", numhl = "1" }
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
    maps.n["<leader>dw"] = { function() require("dapui").elements.watches.add() end, { desc = "Watch", silent = true } }
    maps.n["<leader>df"] = { function() require("dapui").float_element() end, { desc = "Float window", silent = true } }
    vim.keymap.set("n", "<leader>ud", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
    vim.keymap.set("n", "<leader>dh", function() require("dapui").eval() end, { desc = "Dap hover" })
  end,
}
