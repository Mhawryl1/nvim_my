return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "telescope-pathogen.nvim" },
  },
  config = function()
    require("telescope").setup {
      extensions = {
        ["pathogen"] = {
          attach_mappings = function(map, actions)
            map("i", "<C-o>", actions.proceed_with_parent_dir)
            map("i", "<C-l>", actions.revert_back_last_dir)
            map("i", "<C-b>", actions.change_working_directory)
            map("i", "<C-g>g", actions.grep_in_result)
            map("i", "<C-g>i", actions.invert_grep_in_result)
          end,
          -- remove below if you want to enable it
          use_last_search_for_live_grep = false,
          -- quick_buffer_characters = "asdfgqwertzxcvb",
          prompt_prefix_length = 100,
          -- uses a relative path instead of the full path
          relative_prompt_path = false,
          -- customize the prompt suffix after the path
          prompt_suffix = "» ",
        },
      },
    }
    require("telescope").load_extension "pathogen"
    vim.keymap.set("v", "<space>g", require("telescope").extensions["pathogen"].grep_string)
  end,
  keys = {
    { "<space>Fa", ":Telescope pathogen live_grep<CR>", silent = true },
    { "<C-p>", ":Telescope pathogen<CR>", silent = true },
    { "<C-f>", ":Telescope pathogen find_files<CR>", silent = true },
    { "<space>Fg", ":Telescope pathogen grep_string<CR>", silent = true },
  },
}
