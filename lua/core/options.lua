-- global variable
vim.g.toggleFormating = true
-- Set highlight on search
vim.o.hlsearch = true
-- Tab to spaces
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
--autocomplete window max height
vim.o.pumheight = 15
-- keep cursor n line above/below view
vim.opt.scrolloff = 20
-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

vim.o.autoindent = true
vim.o.smartindent = true

vim.o.numberwidth = 6
----
vim.o.wrap = false
-- Disable mouse mode
vim.o.mouse = ""

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

vim.opt.termguicolors = true
vim.opt.autochdir = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set color scheme
--vim.cmd [[colorscheme catppuccin]]
--vim.cmd.colorscheme "catppuccin"

-- Set defauld grep program
vim.o.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = { "%f:%l:%c:%m" }
--vim.cmd()
vim.opt.clipboard = "unnamedplus"

--spell checker
vim.o.spelllang = "en"

vim.o.splitright = true
vim.o.splitbelow = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

-- Concealer for Neorg
vim.o.conceallevel = 0

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
