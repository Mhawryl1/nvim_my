return {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    event = "BufRead",
    config = function()
        vim.api.nvim_set_keymap("n", "<leader>bu", "<cmd>UndotreeToggle<cr>",
            { noremap = true, silent = true, desc = "Toggle undotree" })
    end,
}
