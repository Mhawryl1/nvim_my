return {

  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    wk.setup({
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = " ",
      },
      disable = { filetypes = { "TelescopePrompt" } },
      mode = "n",
      prefix = "<leader>",
    })
    local getIcon = require("core.assets").getIcon
    -----==== Key mapping ====--------
    wk.register({
      H = { "<cmd>Dashboard<cr>", getIcon("ui", "Home", 1) .. "Home" },
      S = { name = "Session" },
      c = {
        function()
          require("core.utils").close_buffer()
        end,
        "Close buffer",
      },
      q = { "<cmd>q<cr>", "Close window" },
      e = { "<cmd>Neotree toggle reveal<cr>", "copen/close explorer" },
      o = {
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd("p")
          else
            vim.cmd.Neotree("focus")
          end
        end,
        "Toggle Explorer Focus",
      },
      Q = { "<Cmd>confirm qall<CR>", "Quit Nvim" },
      l = {
        name = getIcon("ui", "Lsptools", 1) .. "Lsp Tools",
        d = { "<cmd>lua vim.diagnostic.open_float()<cr>", "LSP Show Diagnostics" },
      },
      b = {
        name = getIcon("ui", "NewFile") .. "Buffers",
        l = { "<cmd>BufferLinePick<cr>", "Pick buffer" },
        c = { "<cmd>BufferLineCloseOthers<cr>", "Close all other buffers" },
        t = {
          function()
            require("copilot.suggestion").toggle_auto_trigger()
          end,
          getIcon("ui", "Copilot", 2) .. "Toggle Copilot",
        },
      },
      f = {
        name = " find",
        z = { "<Cmd>Telescope zoxide list<CR>", getIcon("ui", "FolderOpen", 2) .. "Find directories" },
      },
      u = {
        name = " UI",
        s = { ":set spell!<cr>", "toggle spell checker" },
        ["|"] = { "<cmd>IBLToggle<cr>", "Toggle intend scope" },
        f = { "<cmd>lua vim.g.toggleFormating= not vim.g.toggleFormating<cr>", "Toggle formating" },
      },
      t = {
        name = getIcon("ui", "Terminal", 1) .. "terminal",
        h = {
          ":ToggleTerm size=10 direction=horizontal name=dock<cr>",
          getIcon("ui", "Term", 2) .. "toggle horizontal terminal",
        },
        f = {
          function ()
            vim.api.nvim_command(":ToggleTerm size=10 direction=float name=float<cr>")
            vim.api.nvim_command(':doautocmd User LspAttach')
          end,
          getIcon("ui", "Term", 2) .. "toggle float terminal",
        },
        t = { "<cmd>lua _htop_toggle()<cr>", getIcon("ui", "Htop", 2) .. "htop terminal" },
        n = { "<cmd>lua _node_toggle()<cr>", getIcon("ui", "Node", 2) .. "node terminal" },
        p = { "<cmd>lua _python_toggle()<cr>", getIcon("ui", "Python", 2) .. "python terminal" },
      },
      g = {
        name = getIcon("ui", "Git", 1) .. "git",
        g = { "<cmd>lua _lazygit_toggle()<cr>", "LazyGit" },
      },
      x = {
        name = getIcon("diagnostics", "Warning") .. "Truble",
      },
    }, { prefix = "<leader>" })
  end,
}
