vim.api.nvim_buf_set_keymap(0, "n", "o", "<C-]>", { noremap = true, silent = true, desc = "Fallow tagn under cursor" })
vim.api.nvim_buf_set_keymap(0, "n", "tt", ":tabnew %<cr> <C-o>", { noremap = true, silent = true, desc = "Fallow tagn under cursor" })
