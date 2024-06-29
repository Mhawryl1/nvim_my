local map = vim.api
local opts = { noremap = true, silent = true }
map.nvim_set_keymap("i", "jk", "<Esc>", opts)

map.nvim_set_keymap("n", "<S-l>", "<cmd>bnext<cr>", opts)
map.nvim_set_keymap("n", "<S-h>", "<cmd>bprev<cr>", opts)
map.nvim_set_keymap("n", "|", "<cmd>vsplit<cr>", opts)

map.nvim_set_keymap("c", "<C-J>", '<cmd>lua require("cmp").select_next_item()<cr>', opts)
map.nvim_set_keymap("c", "<C-K>", '<cmd>lua require("cmp").select_prev_item()<cr>', opts)
map.nvim_set_keymap("n", "<Esc>", "<cmd>nohls<cr>", opts)
map.nvim_set_keymap("n", "<C-d>", "<C-d>zz", opts)
map.nvim_set_keymap("n", "<C-u>", "<C-u>zz", opts)

map.nvim_set_keymap("i", "<Tab>", "  ", opts)

map.nvim_set_keymap("n", "tt", ":tabnew %<cr>", opts)

vim.keymap.set("n", "<M-j>", ":MoveLine(1)<CR>", opts)
vim.keymap.set("n", "<M-k>", ":MoveLine(-1)<CR>", opts)
vim.keymap.set("v", "<M-j>", ":MoveBlock(1)<CR>", opts)
vim.keymap.set("v", "<M-k>", ":MoveBlock(-1)<CR>", opts)

map.nvim_set_keymap("t", "<esc>", [[<C-\><C-n>]], opts)
map.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], opts)
map.nvim_set_keymap("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
