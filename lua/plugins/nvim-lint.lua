return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      javascript = { "biomejs" },
      typescript = { "biomejs" },
      lua = {"selene"},
      cmake = {"cmake_lint"}
    }
  end,
}
