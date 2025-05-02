local map = vim.api
local opts = { noremap = true, silent = true }
map.nvim_set_keymap("i", "jk", "<Esc>", opts)

map.nvim_set_keymap("n", "<S-l>", "<cmd>bnext<cr>", opts)
map.nvim_set_keymap("n", "<S-h>", "<cmd>bprev<cr>", opts)
vim.keymap.set({ "n", "v" }, "<M-h>", "^", vim.tbl_extend("force", opts, { desc = "Goto begin line" }))
vim.keymap.set({ "n", "v" }, "<M-l>", "g_", vim.tbl_extend("force", opts, { desc = "Goto end line" }))

map.nvim_set_keymap("c", "<C-J>", '<cmd>lua require("cmp").select_next_item()<cr>', opts)
map.nvim_set_keymap("c", "<C-K>", '<cmd>lua require("cmp").select_prev_item()<cr>', opts)
map.nvim_set_keymap("n", "<Esc>", "<cmd>nohls<cr>", opts)
map.nvim_set_keymap("n", "<C-d>", "<C-d>zz", opts)
map.nvim_set_keymap("n", "<C-u>", "<C-u>zz", opts)

map.nvim_set_keymap("n", "tt", ":tabnew %<cr>", opts)

--Stay in indent mode
map.nvim_set_keymap("v", "<", "<gv", opts)
map.nvim_set_keymap("v", ">", ">gv", opts)
--Don't replace text when pasting in visual mode
map.nvim_set_keymap("v", "p", '"_dP', opts)

-- jump to the mark and set the cursor on the midle of the screen
vim.keymap.set("n", "'", function()
  local mark = vim.fn.getcharstr()
  vim.cmd("normal! '" .. mark)
  vim.cmd "normal! zz"
end, { expr = true, silent = true, desc = "Jump to mark and center the screen" })

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
---== terminal keymapping ==---
map.nvim_set_keymap("t", "<esc>", [[<C-\><C-n>]], opts)
map.nvim_set_keymap("t", "<C-j>", "<Down>", { noremap = true })
--map.nvim_set_keymap("t", "jk", [[<C-\><C-n>]], opts)
map.nvim_set_keymap("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
map.nvim_set_keymap("n", "<C-s>", "<cmd>w<cr>", opts)

--paste above and below current line
map.nvim_set_keymap("n", "<M-p>", "<cmd>put!<cr>", opts)
map.nvim_set_keymap("n", "<M-S-p>", "<cmd>put<cr>", opts)
--window resize
map.nvim_set_keymap("n", "<C-w>+", "<C-w>5+", opts)
map.nvim_set_keymap("n", "<C-w>-", "<C-w>5-", opts)
map.nvim_set_keymap("n", "<C-w>>", "<C-w>5>", opts)
map.nvim_set_keymap("n", "<C-w><", "<C-w>5<", opts)
map.nvim_set_keymap("n", "<C-w>|", ":vsplit<CR>", vim.tbl_extend("force", opts, { desc = "Vertical split" }))
map.nvim_set_keymap("n", "<C-w>s", ":split<CR>", vim.tbl_extend("force", opts, { desc = "Horizontal split" }))
map.nvim_set_keymap("n", "<C-w>t", "<C-w>_", vim.tbl_extend("force", opts, { desc = "Maximaze window" }))
map.nvim_set_keymap("n", "<C-w>b", "<C-w>=<C-w>10+", vim.tbl_extend("force", opts, { desc = "Resize to 1/3 " }))
--move between windows
map.nvim_set_keymap("n", "<C-h>", "<C-w>h", opts)
map.nvim_set_keymap("n", "<C-l>", "<C-w>l", opts)

vim.keymap.set({ "n", "s" }, "<C-j>", function()
  if not require("noice.lsp").scroll(4) then return "<C-w>j" end
end, { silent = true, expr = true })

vim.keymap.set({ "n", "s" }, "<C-k>", function()
  if not require("noice.lsp").scroll(-4) then return "<C-w>k" end
end, { silent = true, expr = true })

--ynaki without newline character
map.nvim_set_keymap("n", "<M-c>", "^yg_", vim.tbl_extend("force", opts, { desc = "Yank without newline" }))
map.nvim_set_keymap(
  "n",
  "<C-c>",
  "yg_",
  vim.tbl_extend("force", opts, { desc = "Yank from cur pos to end of the line without newline" })
)
map.nvim_set_keymap("n", "ä", "<cmd>Oil<cr>", vim.tbl_extend("force", opts, { desc = "[Oil] Open parent directory" }))
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
end, { silent = true, desc = "Grep selected" })

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

-- vim.keymap.set({ "n" }, "<C-j>", function()
--   if not require("noice.lsp").scroll(4) then return "<cmd>TmuxNavigateDown<cr>" end
-- end, { silent = true, expr = true })
--
-- vim.keymap.set({ "n" }, "<C-k>", function()
--   if not require("noice.lsp").scroll(-4) then return "<cmd>TmuxNavigateUp<cr>" end
-- end, { silent = true, expr = true })
