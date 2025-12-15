return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local wk = require "which-key"
    wk.setup {
      preset = "classic",
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = " ",
        rules = false,
      },
      disable = { filetypes = { "TelescopePrompt" } },
      mode = "n",
      prefix = "<leader>",
    }

    local getIcon = require("core.assets").getIcon
    -----==== Key mapping ====--------
    wk.add {
      {
        "<leader>z",
        function() require("zen-mode").toggle { window = { width = 0.85 } } end,
        desc = getIcon("ui", "Zen", 1) .. "Toggle Zen-mode",
      },
      { "<leader>d", name = getIcon("ui", "Debugger", 1) .. "Debbug" },
      {
        "<leader>H",
        "<cmd>Dashboard<cr>",
        desc = getIcon("ui", "Home", 1) .. "Home",
      },
      { "<leader>h", name = "harpoon" },
      { "<leader>s", name = "Session" },
      { "<leader>c", function() require("core.utils").close_buffer() end, desc = "Close buffer" },
      {
        "<leader>q",
        "<cmd>q<cr>",
        desc = getIcon("ui", "CloseWin", 1) .. "Close window",
      },
      { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "copen/close explorer" },
      -- {
      --   "<leader>o",
      --   function()
      --     if vim.bo.filetype == "neo-tree" then
      --       vim.cmd.wincmd "p"
      --     else
      --       vim.cmd.Neotree "focus"
      --     end
      --   end,
      --   desc = "Toggle Explorer Focus",
      -- },
      { "<leader>Q", "<Cmd>confirm qall<CR>", desc = "Quit Nvim" },
      { "<leader>l", name = getIcon("ui", "Lsptools", 1) .. "Lsp Tools" },
      { "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "LSP Show Diagnostics" },
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "LSP Code [A]ction" },

      { "<leader>b", name = getIcon("ui", "NewFile") .. "Buffers" }, -- define group of key shorcut
      {
        "<leader>ba",
        "<cmd>bufdo bd<cr>",
        desc = getIcon("ui", "CloseAll", 1) .. "Close all buffer",
      },
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
      { "<leader>bl", function() require("lint").try_lint() end, desc = getIcon("ui", "Linter", 1) .. "Linter buffer" },
      {
        "<leader>bc",
        "<cmd>BufferLineCloseOthers<cr>",
        desc = getIcon("ui", "CloseAll", 1) .. "Close all other buffers",
      },
      {
        "<leader>bd",
        "<cmd>bdelete<cr>",
        desc = getIcon("ui", "DelBuff", 1) .. "Close buffer",
      },
      {
        "<leader>bT",
        "<cmd>Copilot disable<cr>",
        desc = getIcon("ui", "Copilot", 2) .. "Toggle Copilot",
      },
      {
        "<leader>br",
        "<cmd>RenameFile<cr>",
        desc = getIcon("ui", "RenameFile", 1) .. "Rename buffer",
      },
      {
        "<leader>bd",
        function()
          local input = vim.fn.input(getIcon("ui", "DeleteFile", 1) .. "Delete File..", vim.fn.expand "%:t", "file")
          if #input == 0 then return end
          if input == vim.fn.expand "%:t" then input = vim.fn.expand "%:p" end
          vim.api.nvim_command("DeleteFile " .. vim.fn.expand(input))
        end,
        desc = getIcon("ui", "DeleteFile", 1) .. "Delete File",
      },
      { "<leader>bs", "<cmd>SaveAs<cr>", desc = getIcon("ui", "SaveAs", 2) .. "Save as..." },
      { "<leader>bS", "<cmd>wall<cr>", desc = getIcon("ui", "SaveAll", 2) .. "Write all..." },
      { "<leader>bW", "<cmd>SudaWrite<cr>", desc = getIcon("ui", "Sudo", 2) .. "Sudo write..." },
      { "<leader>bR", "<cmd>SudaRead<cr>", desc = getIcon("ui", "Sudo", 2) .. "Sudo read..." },
      { "<leader>bn", "<cmd>NewFile<cr>", desc = getIcon("ui", "NewFile", 2) .. "NewFile..." }, --TODO
      { "<leader>f", name = " find" },
      {
        "<leader>fz",
        "<Cmd>Telescope zoxide list<CR>",
        desc = getIcon("ui", "FolderOpen", 2) .. "FInd dir with zoxide",
      },
      {
        "<leader>fd",
        "<Cmd>Telescope search_dir_picker<CR>",
        desc = getIcon("ui", "FolderOpen", 2) .. "Find directories",
      },
      { "<leader>u", name = " UI" },
      { "<leader>us", ":set spell!<cr>", desc = "toggle spell checker" },
      {
        "<leader>uf",
        function()
          vim.g.toggleFormating = not vim.g.toggleFormating
          local hl_group = require("core.utils").getHLColor()
          if vim.g.toggleFormating then
            vim.api.nvim_set_hl(0, "FormatStatus", { fg = "#c1d00a", bg = hl_group.bg })
          else
            vim.api.nvim_set_hl(0, "FormatStatus", { fg = "#ff0000", bg = hl_group.bg })
          end
        end,
        desc = "Toggle formating",
      },
      { "<leader>u|", "<cmd>IBLToggle<cr>", desc = "Toggle intend scope" },
      { "<leader>t", name = getIcon("ui", "Terminal", 1) .. "terminal" },
      {
        "<leader>th",
        ":ToggleTerm size=10 direction=horizontal name=term<cr>",
        desc = getIcon("ui", "Term", 2) .. "toggle horizontal terminal",
      },
      {
        "<leader>tv",
        ":ToggleTerm size=60 direction=vertical name=term<cr>",
        desc = getIcon("ui", "Term", 2) .. "toggle horizontal terminal",
      },
      {
        "<a-cr>",
        ":ToggleTerm size=60 direction=vertical name=term<cr>",
        desc = getIcon("ui", "Term", 2) .. "toggle horizontal terminal",
      },
      {
        "<leader>tf",
        function()
          vim.api.nvim_command ":ToggleTerm size=10 direction=float name=float zsh"
          vim.api.nvim_command ":doautocmd User LspAttach"
        end,
        desc = getIcon("ui", "Term", 2) .. "toggle float terminal",
      },
      {
        "<leader>tt",
        "<cmd>lua _htop_toggle()<cr>",
        desc = getIcon("ui", "Htop", 2) .. "htop terminal",
      },
      {
        "<leader>te",
        "<cmd>Yazi<cr>",
        desc = getIcon("ui", "Files", 2) .. "yazi file exaplorer",
      },
      {
        "<leader>tc",
        "<cmd>lua _btop_toggle()<cr>",
        desc = getIcon("ui", "Htop", 2) .. "btop terminal",
      },
      {
        "<leader>tn",
        "<cmd>lua _node_toggle()<cr>",
        desc = getIcon("ui", "Node", 2) .. "node terminal",
      },
      {
        "<leader>tp",
        "<cmd>lua _python_toggle()<cr>",
        desc = getIcon("ui", "Python", 2) .. "python terminal",
      },
      {
        "<leader>tg",
        "<cmd>lua _gdu_toggle()<cr>",
        desc = getIcon("ui", "Tools", 2) .. "GDU toggle",
      },
      {
        "<leader>tb",
        "<cmd>lua _btm_toggle()<cr>",
        desc = getIcon("ui", "Tools", 2) .. "BTM toggle",
      },
      { "<leader>g", name = getIcon("ui", "Git", 1) .. "git" },
      { "<leader>gg", "<cmd>lua _lazygit_toggle()<cr>", desc = "LazyGit" },
      { "<leader>x", name = getIcon("diagnostics", "Warning") .. "Truble" },
      { "<leader>p", name = getIcon("ui", "Package") .. "Package" },
      { "<leader>pm", "<cmd>Mason<cr>", desc = "Open Mason" },
      { "<leader>pl", "<cmd>Lazy<cr>", desc = "Open Lazy" },
      { "<leader>pu", "<cmd>MasonUpdate<cr>", desc = getIcon("ui", "Update", 2) .. "Update mason package" },
      { "<leader>pp", "<cmd>Lazy update<cr>", desc = getIcon("ui", "Update", 2) .. "Update Lazy package" },
    }
  end,
}
