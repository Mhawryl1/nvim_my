return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
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
      { "<leader>S", name = "Session" },
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
      { "<leader>b", name = getIcon("ui", "NewFile") .. "Buffers" },
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
        function()
          local input = vim.fn.input(getIcon("ui", "RenameFile", 1) .. "Rename file..")
          if #input > 0 then vim.api.nvim_command("RenameFile " .. input) end
        end,
        desc = getIcon("ui", "RenameFile", 1) .. "Rename buffer",
      },
      { "<leader>bs", "<cmd>SaveAs<cr>", desc = getIcon("ui", "SaveAs", 2) .. "Save as..." },
      { "<leader>bS", "<cmd>wall<cr>", desc = getIcon("ui", "SaveAll", 2) .. "Save all..." },
      { "<leader>f", name = " find" },
      { "<leader>fz", "<Cmd>Telescope zoxide list<CR>", desc = getIcon("ui", "FolderOpen", 2) .. "Find directories" },
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
        "<leader>tf",
        function()
          vim.api.nvim_command ":ToggleTerm size=10 direction=float name=float<cr>"
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
        desc = getIcon("ui", "FolderClosed", 2) .. "yazi file exaplorer",
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
      -- { "<leader>p",  name = getIcon("ui", "Package") .. "Package" },
      -- { "<leader>pm", "<cmd>MasonUpdate<cr>",                              desc = "Update mason package" },
      -- { "<leader>pl", "<cmd>Lazy update<cr>",                              desc = "Update Lazy package" },
    }
  end,
}
