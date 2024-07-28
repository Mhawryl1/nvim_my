local map = vim.api
local opts = { noremap = true, silent = true }
map.nvim_set_keymap("i", "jk", "<Esc>", opts)

map.nvim_set_keymap("n", "<S-l>", "<cmd>bnext<cr>", opts)
map.nvim_set_keymap("n", "<S-h>", "<cmd>bprev<cr>", opts)
map.nvim_set_keymap("n", "<M-h>", "^", vim.tbl_extend("force", opts, { desc = "Goto begin line" }))
map.nvim_set_keymap("n", "<M-l>", "g_", vim.tbl_extend("force", opts, { desc = "Goto end line" }))

map.nvim_set_keymap("c", "<C-J>", '<cmd>lua require("cmp").select_next_item()<cr>', opts)
map.nvim_set_keymap("c", "<C-K>", '<cmd>lua require("cmp").select_prev_item()<cr>', opts)
map.nvim_set_keymap("n", "<Esc>", "<cmd>nohls<cr>", opts)
map.nvim_set_keymap("n", "<C-d>", "<C-d>zz", opts)
map.nvim_set_keymap("n", "<C-u>", "<C-u>zz", opts)

map.nvim_set_keymap("n", "tt", ":tabnew %<cr>", opts)
map.nvim_set_keymap("n", "<C-k>", "<C-w>k", opts)

--Stay in indent mode
map.nvim_set_keymap("v", "<", "<gv", opts)
map.nvim_set_keymap("v", ">", ">gv", opts)
--Don't replace text when pasting in visual mode
map.nvim_set_keymap("v", "p", '"_dP', opts)

-- Type a replacment term and press . to replace the next occurence or n to skip to the next occurence
vim.keymap.set(
  "n",
  "s*",
  "<cmd>let @/='\\<'.expand('<cword>').'\\>'<CR>cgn",
  vim.tbl_extend("force", opts, { desc = "Change word under the cursor and press . to repeat for next occurence" })
)
vim.keymap.set(
  "x",
  "s*",
  '"sy<esc>:let @/=@s<CR>cgn',
  vim.tbl_extend("force", opts, { desc = "Change selection and press . to repeat for next occurence" })
)

vim.keymap.set("n", "<M-j>", ":MoveLine(1)<CR>", opts)
vim.keymap.set("n", "<M-k>", ":MoveLine(-1)<CR>", opts)
vim.keymap.set("v", "<M-j>", ":MoveBlock(1)<CR>", opts)
vim.keymap.set("v", "<M-k>", ":MoveBlock(-1)<CR>", opts)

map.nvim_set_keymap("t", "<esc>", [[<C-\><C-n>]], opts)
map.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], opts)
map.nvim_set_keymap("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
map.nvim_set_keymap("n", "<C-s>", "<cmd>w<cr>", opts)

map.nvim_set_keymap("n", "<M-p>", "<cmd>put!<cr>", opts)
map.nvim_set_keymap("n", "<M-S-p>", "<cmd>put<cr>", opts)
--window resize
map.nvim_set_keymap("n", "<C-w>+", "<C-w>5+", opts)
map.nvim_set_keymap("n", "<C-w>-", "<C-w>5-", opts)
map.nvim_set_keymap("n", "<C-w>>", "<C-w>5>", opts)
map.nvim_set_keymap("n", "<C-w><", "<C-w>5<", opts)
map.nvim_set_keymap("n", "<C-w>f", "<C-w>|", opts)
map.nvim_set_keymap("n", "<C-w>t", "<C-w>_", opts)

---ynaki without newline character
map.nvim_set_keymap("n", "<M-c>", "^yg_", vim.tbl_extend("force", opts, { desc = "Yank without newline" }))
map.nvim_set_keymap(
  "n",
  "<C-c>",
  "yg_",
  vim.tbl_extend("force", opts, { desc = "Yank from cur pos to end of the line without newline" })
)
------------====Grepper keymapping====------------
local function sendToQuickFix(result)
  local lines = vim.split(result, "\n")
  local qflist = {}
  for _, line in ipairs(lines) do
    local filename, lnum, col, text = string.match(line, "(.*):(%d+):(%d+):(.*)")
    if filename and lnum and col and text then
      table.insert(qflist, {
        filename = filename,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = text,
      })
    end
  end
  vim.fn.setqflist(qflist)
  vim.cmd "copen"
end

vim.keymap.set({ "n", "s" }, "<leader>gw", function()
  local word = vim.fn.expand "<cword>"
  local result = vim.fn.system("rg --vimgrep --no-heading -s " .. '"' .. "\\b" .. word .. "\\b" .. '"')
  sendToQuickFix(result)
end, { silent = true, desc = "Grep word under cursor" })

vim.keymap.set({ "v" }, "<leader>gw", function()
  vim.cmd 'noau normal! "vy"'
  local selection = vim.fn.getreg "v"
  selection = selection:gsub('"', '\\"')
  selection = '"' .. selection .. '"'
  local result = vim.fn.system("rg -F -U --vimgrep --no-heading --smart-case " .. selection)
  sendToQuickFix(result)
end, { silent = true, desc = "Grep selection cursor" })

---open close hover window
vim.keymap.set({ "n", "s" }, "<S-k>", function()
  local base_win_id = vim.api.nvim_get_current_win()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  for _, win_id in ipairs(windows) do
    if win_id ~= base_win_id then
      local win_cfg = vim.api.nvim_win_get_config(win_id)
      if win_cfg.relative == "win" and win_cfg.win == base_win_id then
        require("noice.lsp.docs").hide(require("noice.lsp.docs").get "hover")
        return
      end
    end
  end
  require("noice.lsp").hover()
end, { remap = false, silent = true, desc = "Lsp hover" })

-----====lsp keymapping====-----
vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if not require("noice.lsp").scroll(4) then return "<c-j>" end
end, { silent = true, expr = true })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if not require("noice.lsp").scroll(-4) then return "<c-k>" end
end, { silent = true, expr = true })

vim.keymap.set({ "n" }, "<C-j>", function()
  if not require("noice.lsp").scroll(4) then return "<cmd>TmuxNavigateDown<cr>" end
end, { silent = true, expr = true })

vim.keymap.set({ "n" }, "<C-k>", function()
  if not require("noice.lsp").scroll(-4) then return "<cmd>TmuxNavigateUp<cr>" end
end, { silent = true, expr = true })
