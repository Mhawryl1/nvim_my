return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup {
      autochdir = true,
      shade_terminal = true,
      shade_terminals = true,
      shading_factor = "-10", -- the percentage by which to lighten dark terminal background, default: -30
      shading_ratio = "-1",   -- the ratio of shading factor for light/dark terminal background, default: -3
      start_in_insert = true,
      shell = vim.o.shell,
      title_pos = "center",
    }

    local Terminal = require("toggleterm.terminal").Terminal
    ----===lazygit ===----
    local lazygit = Terminal:new {
      cmd = "lazygit",
      display_name = "Lazygit",
      hidden = true,
      direction = "float",
      close_on_exit = true,
      float_opts = {
        border = "curved",
      },
      on_open = function(term)
        vim.cmd "startinsert!"
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_del_keymap("t", "jk")
        vim.api.nvim_del_keymap("t", "<esc>")
      end,
      on_close = function(term)
        vim.cmd "startinsert!"
        vim.api.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "<esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
      end,
    }

    function _G._lazygit_toggle() lazygit:toggle() end

    ----=== htop === -------
    local htop = Terminal:new {
      cmd = "htop",
      hidden = true,
      direction = "float",
      close_on_exit = true,
      display_name = "HTOP",
      float_opts = {
        border = "double",
      },
      on_open = function(term)
        vim.cmd "startinsert!"
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "j", "<Down>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "k", "<Up>", { noremap = true, silent = true })
        vim.api.nvim_del_keymap("t", "jk")
        vim.api.nvim_del_keymap("t", "<esc>")
      end,
      on_close = function(term)
        vim.cmd "startinsert!"
        vim.api.nvim_del_keymap("t", "j")
        vim.api.nvim_del_keymap("t", "k")
        vim.api.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "<esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
      end,
    }
    function _G._htop_toggle() htop:toggle() end

    -------=== node ===---------
    local node = Terminal:new {
      cmd = "node",
      hidden = true,
      direction = "float",
      close_on_exit = true,
      display_name = "node",
      float_opts = {
        border = "curved",
      },
    }
    function _G._node_toggle() node:toggle() end

    -----------=== Python ===---------
    local python = Terminal:new {
      cmd = "python3",
      hidden = true,
      direction = "float",
      close_on_exit = true,
      display_name = "python3",
      float_opts = {
        border = "curved",
      },
    }
    function _G._python_toggle() python:toggle() end

    -----------=== gdu ===---------
    local gdu = Terminal:new {
      cmd = "gdu",
      hidden = true,
      direction = "float",
      close_on_exit = true,
      display_name = "gdu",
      float_opts = {
        border = "curved",
      },
      on_open = function(term)
        vim.cmd "startinsert!"
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "j", "<Down>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "k", "<Up>", { noremap = true, silent = true })
        vim.api.nvim_del_keymap("t", "jk")
        vim.api.nvim_del_keymap("t", "<esc>")
      end,
      on_close = function(term)
        vim.cmd "startinsert!"
        vim.api.nvim_del_keymap("t", "j")
        vim.api.nvim_del_keymap("t", "k")
        vim.api.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "<esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
      end,
    }
    function _G._gdu_toggle() gdu:toggle() end

    -----------=== btm ===---------
    local btm = Terminal:new {
      cmd = "btm",
      hidden = true,
      direction = "float",
      close_on_exit = true,
      display_name = "btm",
      float_opts = {
        border = "curved",
      },
      on_open = function(term)
        vim.cmd "startinsert!"
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "j", "<Down>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "k", "<Up>", { noremap = true, silent = true })
        vim.api.nvim_del_keymap("t", "jk")
        vim.api.nvim_del_keymap("t", "<esc>")
      end,
      on_close = function(term)
        vim.cmd "startinsert!"
        vim.api.nvim_del_keymap("t", "j")
        vim.api.nvim_del_keymap("t", "k")
        vim.api.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true })
        vim.api.nvim_set_keymap("t", "<esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
      end,
    }
    function _G._btm_toggle() btm:toggle() end
  end,
}
