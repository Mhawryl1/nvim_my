local map = vim.api
local opts = { noremap = true, silent = true }
map.nvim_set_keymap("i", "jk", "<Esc>", opts)

map.nvim_set_keymap("n", "<S-l>", "<cmd>bnext<cr>", opts)
map.nvim_set_keymap("n", "<S-h>", "<cmd>bprev<cr>", opts)
map.nvim_set_keymap("n", "<C-w>|", "<cmd>vsplit<cr><C-W>l", opts)
map.nvim_set_keymap("n", "<C-w>_", "<cmd>split<cr>", opts)

map.nvim_set_keymap("c", "<C-J>", '<cmd>lua require("cmp").select_next_item()<cr>', opts)
map.nvim_set_keymap("c", "<C-K>", '<cmd>lua require("cmp").select_prev_item()<cr>', opts)
map.nvim_set_keymap("n", "<Esc>", "<cmd>nohls<cr>", opts)
map.nvim_set_keymap("n", "<C-d>", "<C-d>zz", opts)
map.nvim_set_keymap("n", "<C-u>", "<C-u>zz", opts)

map.nvim_set_keymap("i", "<Tab>", "  ", opts)
map.nvim_set_keymap("n", "tt", ":tabnew %<cr>", opts)
map.nvim_set_keymap("n", "<C-k>", "<C-w>k", opts)

vim.keymap.set("n", "<M-j>", ":MoveLine(1)<CR>", opts)
vim.keymap.set("n", "<M-k>", ":MoveLine(-1)<CR>", opts)
vim.keymap.set("v", "<M-j>", ":MoveBlock(1)<CR>", opts)
vim.keymap.set("v", "<M-k>", ":MoveBlock(-1)<CR>", opts)

map.nvim_set_keymap("t", "<esc>", [[<C-\><C-n>]], opts)
map.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], opts)
map.nvim_set_keymap("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
map.nvim_set_keymap("n", "<C-s>", "<cmd>w<cr>", opts)

map.nvim_set_keymap("n", "<C-w>+", "<C-w>5+", opts)
map.nvim_set_keymap("n", "<C-w>-", "<C-w>5-", opts)
map.nvim_set_keymap("n", "<C-w>>", "<C-w>5>", opts)
map.nvim_set_keymap("n", "<C-w><", "<C-w>5<", opts)

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-j>"
  end
end, { silent = true, expr = true })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-k"
  end
end, { silent = true, expr = true })

vim.keymap.set({ "n" }, "<C-j>", function()
  if not require("noice.lsp").scroll(4) then
    return "<cmd>TmuxNavigateDown<cr>"
  end
end, { silent = true, expr = true })

vim.keymap.set({ "n" }, "<C-k>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<cmd>TmuxNavigateUp<cr>"
  end
end, { silent = true, expr = true })
