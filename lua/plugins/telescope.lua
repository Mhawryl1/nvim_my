return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    {
      "AckslD/nvim-neoclip.lua",
      dependencies = { "kkharji/sqlite.lua", module = "sqlite" },
    },
    "ahmedkhalf/project.nvim",
  },

  config = function()
    local telescope = require "telescope"
    local actions = require "telescope.actions"
    local fb_actions = require("telescope").extensions.file_browser.actions
    local is_git_repo = require("core.utils").is_git_repo
    --local transform_mod = require("telescope.actions.mt").transform_mod

    -- local trouble = require("trouble")
    local open_with_trouble = require("trouble.sources.telescope").open
    -- or create your custom action
    -- local custom_actions = transform_mod({
    --   open_trouble_qflist = function(prompt_bufnr)
    --     trouble.toggle("quickfix")
    --   end,
    -- })
    --
    require("telescope").load_extension "noice"
    require("telescope").load_extension "neoclip"
    require("neoclip").setup {
      history = 1000,
      enable_persistent_history = true,
      length_limit = 1048576,
      continuous_sync = false,
      db_path = vim.fn.stdpath "data" .. "/databases/neoclip.sqlite3",
      filter = nil,
      preview = true,
      prompt = nil,
      default_register = '"',
      default_register_macros = "q",
      enable_macro_history = true,
      content_spec_column = false,
      disable_keycodes_parsing = false,
      dedent_picker_display = false,
      initial_mode = "insert",
      keys = {
        telescope = {
          i = {
            select = "<cr>",
            paste = "<c-p>",
            paste_behind = "<c-b>",
            replay = "<c-q>", -- replay a macro
            delete = "<c-d>", -- delete an entry
            edit = "<c-e>", -- edit an entry
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            custom = {},
          },
          n = {
            select = "<cr>",
            --paste = "p",
            --- It is possible to map to more than one key.
            paste = { "p", "<c-p>" },
            paste_behind = "P",
            replay = "q",
            delete = "d",
            edit = "e",
            ["k>"] = actions.move_selection_previous, -- move to prev result
            ["j>"] = actions.move_selection_next, -- move to next result
            custom = {},
          },
        },
        fzf = {
          select = "default",
          paste = "ctrl-p",
          paste_behind = "ctrl-b",
          custom = {},
        },
      },
    }
    telescope.setup {
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<c-t>"] = open_with_trouble,
            --["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
          },
          n = { ["<C-t>"] = open_with_trouble },
        },
      },
      extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          mappings = {
            n = {
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["/"] = function() vim.cmd "startinsert" end,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
              ["<C-j>"] = actions.preview_scrolling_up,
              ["<C-k>"] = actions.preview_scrolling_down,
            },
          },
        },
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
        fzf = {},
      },
    }
    require("telescope").load_extension "projects"
    require("telescope").load_extension "undo"
    local getIcon = require("core.assets").getIcon
    vim.keymap.set(
      "n",
      "<leader>bt",
      "<cmd>Telescope undo<cr>",
      { noremap = true, silent = true, desc = getIcon("ui", "Telescope", 1) .. "Browse undo history" }
    )

    local is_available = require("core.utils").is_available
    local maps = require("core.utils").maps
    local builtin = require "telescope.builtin"
    local get_icon = require("core.assets").getIcon

    maps.n["<leader>fp"] = {
      function() require("telescope").extensions.projects.projects {} end,
      { desc = getIcon("ui", "Project", 1) .. "Find projects" },
    }
    maps.n["<leader>y"] = {
      "<cmd>lua require('telescope').extensions.neoclip.default(require('telescope.themes').get_dropdown({}))<CR>",
      { desc = "Yank history" },
    }
    maps.n["<leader>gb"] =
      { function() require("telescope").extensions.file_browser.file_browser() end, { desc = "File Browser" } }
    maps.n["<leader>ut"] = { function() builtin.colorscheme { enable_preview = true } end, { desc = "Find themse" } }

    maps.n["<leader>xd"] = { function() builtin.diagnostics() end, { desc = "Search diagnostics" } }

    maps.n["<leader>ls"] = {
      function()
        if is_available "aerial.nvim" then
          require("telescope").extensions.aerial.aerial()
        else
          builtin.lsp_document_symbols()
        end
      end,
      { desc = "Search symbols" },
    }

    maps.n["<leader>f<CR>"] = { function() builtin.resume() end, { desc = "Resume previous search" } }

    maps.n["<leader>f/"] =
      { function() builtin.current_buffer_fuzzy_find() end, { desc = "Find words in current buffer" } }

    maps.n["<leader>fa"] = {
      function() builtin.find_files { prompt_title = "Config Files", cwd = vim.fn.stdpath "config", follow = true } end,
      { desc = get_icon("ui", "Config", 1) .. "Find Nvim config files" },
    }

    maps.n["<leader>fb"] = { function() builtin.buffers() end, { desc = "Find buffer" } }
    maps.n["<leader>fc"] =
      { function() builtin.grep_string() end, { desc = getIcon("ui", "Word", 1) .. "Find word under cursor" } }
    maps.n["<leader>fC"] = { function() builtin.commands() end, { desc = "Find commands" } }
    maps.n["<leader>ff"] = {
      function() builtin.find_files { hidden = true, no_ignore = true } end,
      { desc = get_icon("ui", "FindFiles", 2) .. "Find Files" },
    }
    maps.n["<leader>fF"] =
      { function() builtin.find_files { hidden = true, no_ignore = true } end, { desc = "Find all files" } }
    maps.n["<leader>fr"] = { function() builtin.registers() end, { desc = "Find registers" } }
    maps.n["<leader>fk"] =
      { function() builtin.keymaps() end, { desc = get_icon("ui", "Keyboard", 1) .. "Find keymaps" } }
    maps.n["<leader>fm"] = { function() builtin.man_pages() end, { desc = get_icon("ui", "Note", 1) .. "Find man" } }
    maps.n["<leader>fn"] = {
      function() require("telescope").extensions.notify.notify() end,
      { desc = get_icon("diagnostics", "DiagnosticInfo", 1) .. "Find notifications" },
    }
    maps.n["<leader>fo"] = { function() builtin.oldfiles() end, { desc = "Old files" } }

    maps.n["<leader>fh"] = { function() builtin.help_tags() end, { desc = get_icon("ui", "Help", 1) .. "Find help" } }
    maps.n["<leader>fw"] = { function() builtin.live_grep() end, { desc = "Find words" } }
    maps.n["<leader>fW"] = {
      function()
        builtin.live_grep {
          additional_args = function(opts) return { "--hidden", "--no-ignore" } end,
        }
      end,
      { desc = "Find words in all files" },
    }
    maps.n["<leader>gc"] = {
      function()
        if not is_git_repo() then
          vim.notify(" Can't find git repo directory", vim.log.levels.INFO, { title = "Git rep status" })
          return
        end
        require("telescope.builtin").git_bcommits { use_file_path = true }
      end,
      { desc = "Git commits (current file)" },
    }
    telescope.load_extension "file_browser"
    telescope.load_extension "fzf"
    require("core.utils.multigrep").setup()
  end,
}
