return {

  "folkcopeFuzzyCommandSearch)j/which-key.nvim",
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
    local getIcon = require("core.config").getIcon
    -----==== Key mapping ====--------
    wk.register({
      c = {
        function()
          require("core.polish").close_buffer()
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
        name = getIcon("ui", "Lsptools", 2) .. "Lsp Tools",
        d = {
          function()
            vim.diagnostic.setloclist()
          end,
          "LSP Show Diagnostics",
        },
      },
      b = {
        name = getIcon("ui", "NewFile") .. "Buffers",
        l = { "<cmd>BufferLinePick<cr>", "Pick buffer" },
        c = { "<cmd>BufferLineCloseOthers<cr>", "Close all other buffers" },
      },
      f = {
        name = " find",
        b = {
          function()
            require("telescope.builtin").buffers()
          end,
          "Find buffer",
        },
        f = {
          function()
            require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
          end,
          "Find Files",
        },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        n = { "<cmd>enew<cr>", "New File" },
        o = {
          function()
            require("telescope.builtin").oldfiles()
          end,
          "Old files",
        },
        k = {
          function()
            require("telescope.builtin").keymaps()
          end,
          "Find keymaps",
        },
        m = {
          function()
            require("telescope.builtin").man_pages()
          end,
          "Find man",
        },
        c = {
          function()
            require("telescope.builtin").git_bcommits({ use_file_path = true })
          end,
          "Git commits (current file)",
        },
        g = {
          function()
            require("telescope.builtin").git_bcommits({ use_file_path = true })
          end,
          "Git commits (current file)",
        },
        z = { "<Cmd>Telescope zoxide list<CR>", "Find directories" },
        w = {
          function()
            require("telescope.builtin").live_grep()
          end,
          "Find words",
        },
        W = {
          function()
            require("telescope.builtin").live_grep({
              additional_args = function(args)
                return vim.list_extend(args, { "--hidden", "--no-ignore" })
              end,
            })
          end,
          "Find words in all files",
        },
      },
      u = {
        name = " UI",
        s = { ":set spell!<cr>", "toggle spell checker" },
        t = {
          function()
            require("telescope.builtin").colorscheme({ enable_preview = true })
          end,
          "Find themes",
        },
        ["|"] = { "<cmd>IBLToggle<cr>", "Toggle intend scope" },
        f = { "<cmd>lua vim.g.toggleFormating= not vim.g.toggleFormating<cr>", "Toggle formating" },
      },
      t = {
        name = getIcon("ui", "Terminal") .. "terminal",
        h = {
          ":ToggleTerm size=10 direction=horizontal name=dock<cr>",
          getIcon("ui", "Term", 2) .. "toggle horizontal terminal",
        },
        f = {
          ":ToggleTerm size=10 direction=float name=float<cr>",
          getIcon("ui", "Term", 2) .. "toggle float terminal",
        },
        t = { "<cmd>lua _htop_toggle()<cr>", getIcon("ui", "Htop", 2) .. "htop terminal" },
        n = { "<cmd>lua _node_toggle()<cr>", getIcon("ui", "Node", 2) .. "node terminal" },
        p = { "<cmd>lua _python_toggle()<cr>", getIcon("ui", "Python", 2) .. "python terminal" },
      },
      g = {
        name = getIcon("ui", "Git", 2) .. "git",
        g = { "<cmd>lua _lazygit_toggle()<cr>", "LazyGit" },
      },
    }, { prefix = "<leader>" })
  end,
}
