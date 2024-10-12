if true then return {} end
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
      defaults = {
        runtime = vim.env.VIMRUNTIME --[[@as string]],
        library = { plugins = { "nvim-dap-ui" }, types = true },
        integrations = {
          -- Fixes lspconfig's workspace management for LuaLS
          -- Only create a new workspace if the buffer is not part
          -- of an existing workspace or one of its libraries
          lspconfig = true,
          -- add the cmp source for completion of:
          -- `require "modname"`
          -- `---@module "modname"`
          cmp = true,
          -- same, but for Coq
          coq = false,
        },
        ---@type boolean|(fun(root:string):boolean?)
        enabled = function(root_dir) return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled end,
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
}
