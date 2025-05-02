return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup {
      detection_methods = { "lsp", "pattern" },
      -- Manual mode doesn't automatically change your root directory, so you have
      -- the option to manually do so using `:ProjectRoot` command.
      manual_mode = true,
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        "compile_commands.json",
        ".csproj",
      },
      ----===Default mappings ===----
      -- f	<c-f>	find_project_files
      -- b	<c-b>	browse_project_files
      -- d	<c-d>	delete_project
      -- s	<c-s>	search_in_project_files
      -- r	<c-r>	recent_project_files
      -- w	<c-w>	change_working_director
    }
  end,
}
