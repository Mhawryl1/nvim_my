return {
  "ThePrimeagen/harpoon",
  event = "BufWinEnter",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local harpoon = require "harpoon"
    harpoon:setup()
    local conf = require("telescope.config").values

    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end
    vim.keymap.set("n", "<leader>hu", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })

    vim.api.nvim_set_keymap(
      "n",
      "<leader>ht",
      "<cmd>lua  require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>",
      { noremap = true, silent = true, desc = "Toggle Harpoon UI" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>ha",
      "<cmd>lua require('harpoon'):list():add()<cr>",
      { noremap = true, silent = true, desc = "Add file" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hh",
      "<cmd>lua require('harpoon'):list():select(1)<cr>",
      { noremap = true, silent = true, desc = "Got to buffer 1" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hj",
      "<cmd>lua require('harpoon'):list():select(2)<cr>",
      { noremap = true, silent = true, desc = "Got to buffer 2" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hk",
      "<cmd>lua require('harpoon'):list():select(1)<cr>",
      { noremap = true, silent = true, desc = "Got to buffer 3" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hl",
      "<cmd>lua require('harpoon'):list():select(1)<cr>",
      { noremap = true, silent = true, desc = "Got to buffer 4" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hn",
      "<cmd>lua require('harpoon'):list():next()<cr>",
      { noremap = true, silent = true, desc = "Select next buffer" }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>hp",
      "<cmd>lua require('harpoon'):list():prev()<cr>",
      { noremap = true, silent = true, desc = "Select prev buffer" }
    )
    for i = 1, 5 do
      vim.api.nvim_set_keymap(
        "n",
        "°" .. i,
        "<cmd>lua require('harpoon'):list():select(" .. i .. ")<cr>",
        { noremap = true, silent = true, desc = "select " .. i .. " buffer from list" }
      )
    end
  end,
}
