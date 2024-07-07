--if true then return {} end
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "debugloop/telescope-undo.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    --local transform_mod = require("telescope.actions.mt").transform_mod

    -- local trouble = require("trouble")
    local open_with_trouble = require("trouble.sources.telescope").open
    -- or create your custom action
    -- local custom_actions = transform_mod({
    --   open_trouble_qflist = function(prompt_bufnr)
    --     trouble.toggle("quickfix")
    --   end,
    -- })

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<c-t>"] = open_with_trouble,
            --["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
          },
          --n = { ["<C-t>"] = open_with_trouble },
        },
      },
      extensions = {
        mappings = {
          i = {
            ["<cr>"] = require("telescope-undo.actions").yank_additions,
            ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
            ["<C-cr>"] = require("telescope-undo.actions").restore,
            -- alternative defaults, for users whose terminals do questionable things with modified <cr>
            ["<C-y>"] = require("telescope-undo.actions").yank_deletions,
            ["<C-r>"] = require("telescope-undo.actions").restore,
          },
          n = {
            ["y"] = require("telescope-undo.actions").yank_additions,
            ["Y"] = require("telescope-undo.actions").yank_deletions,
            ["u"] = require("telescope-undo.actions").restore,
          },
        },
        -- undo = {
        --   use_delta = true,
        --   side_by_side = true,
        --   entry_format = "state #$ID, $STAT, $TIME",
        --   layout_strategy = "vertical",
        --   vim_diff_opts = { ctxlen = 999 },
        --   layout_config = {
        --     preview_height = 0.8,
        --   },
        -- },
      },
    })
    require("telescope").load_extension("undo")
    vim.keymap.set("n", "<leader>bu", "<cmd>Telescope undo<cr>",
      { noremap = true, silent = true, desc = "Browse undo history" })

    local is_available = require("core.utils").is_available
    local maps = require("core.utils").maps
    local builtin = require("telescope.builtin")
    local get_icon = require("core.assets").getIcon
    maps.n["<leader>ut"] = {
      function()
        builtin.colorscheme({ enable_preview = true })
      end,
      { desc = "Find themse" },
    }

    maps.n["<leader>xd"] = {
      function()
        builtin.diagnostics()
      end,
      { desc = "Search diagnostics" },
    }

    maps.n["<leader>ls"] = {
      function()
        if is_available("aerial.nvim") then
          require("telescope").extensions.aerial.aerial()
        else
          builtin.lsp_document_symbols()
        end
      end,
      { desc = "Search symbols" },
    }

    maps.n["<leader>f<CR>"] = {
      function()
        builtin.resume()
      end,
      { desc = "Resume previous search" },
    }

    maps.n["<leader>f/"] = {
      function()
        builtin.current_buffer_fuzzy_find()
      end,
      { desc = "Find words in current buffer" },
    }

    maps.n["<leader>fa"] = {
      function()
        builtin.find_files({
          prompt_title = "Config Files",
          cwd = vim.fn.stdpath("config"),
          follow = true,
        })
      end,
      { desc = "Find AstroNvim config files" },
    }

    maps.n["<leader>fb"] = {
      function()
        builtin.buffers()
      end,
      { desc = "Find buffer" },
    }
    maps.n["<leader>fc"] = {
      function()
        builtin.grep_string()
      end,
      { desc = "Find word under cursor" },
    }
    maps.n["<leader>fC"] = {
      function()
        builtin.commands()
      end,
      { desc = "Find commands" },
    }
    maps.n["<leader>ff"] = {
      function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end,
      { desc = "Find Files" },
    }
    maps.n["<leader>fF"] = {
      function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end,
      { desc = "Find all files" },
    }
    maps.n["<leader>fr"] = {
      function()
        builtin.registers()
      end,
      { desc = "Find registers" },
    }
    maps.n["<leader>fk"] = {
      function()
        builtin.keymaps()
      end,
      { desc = "Find keymaps" },
    }
    maps.n["<leader>fm"] = {
      function()
        builtin.man_pages()
      end,
      { desc = get_icon("ui", "Note", 1) .. "Find man" },
    }
    maps.n["<leader>fn"] = {
      function()
        require("telescope").extensions.notify.notify()
      end,
      { desc = "Find notifications" },
    }
    maps.n["<leader>fo"] = {
      function()
        builtin.oldfiles()
      end,
      { desc = "Old files" },
    }

    maps.n["<leader>fh"] = {
      function()
        builtin.help_tags()
      end,
      { desc = "Find help" },
    }
    maps.n["<leader>fw"] = {
      function()
        builtin.live_grep()
      end,
      { desc = "Find words" },
    }
    maps.n["<leader>fW"] = {
      function()
        builtin.live_grep({
          additional_args = function(args)
            return vim.list_extend(args, { "--hidden", "--no-ignore" })
          end,
        })
      end,
      { desc = "Find words in all files" },
    }
    maps.n["<leader>gc"] = {
      function()
        require("telescope.builtin").git_bcommits({ use_file_path = true })
      end,
      { desc = "Git commits (current file)" },
    }

    telescope.load_extension("fzf")
  end,
}
