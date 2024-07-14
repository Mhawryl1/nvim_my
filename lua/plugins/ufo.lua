return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async", "luukvbaal/statuscol.nvim" },
  event = "VimEnter",
  opts = {
    -- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
    provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end,
    open_fold_hl_timeout = 200,
    close_fold_kinds_for_ft = { "imports", "comment" },
    preview = {
      win_config = {
        border = { "", "─", "", "", "", "─", "", "" },
        winhighlight = "Normal:Folded",
        winblend = 0,
      },
    },
  },
  init = function()
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    -- turn off foldcolumn for neotree to ovoid showing ugly numbers in neotree
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "neo-tree" then
          vim.opt_local.foldcolumn = "0"
          vim.opt_local.foldenable = false
        end
      end,
      group = vim.api.nvim_create_augroup("NeoTreeSettings", { clear = true }),
    })
  end,
  config = function(_, opts)
    local maps = require("core.utils").maps
    local builtin = require "statuscol.builtin"
    local ufo = require "ufo"
    local get_icon = require("core.assets").getIcon
    require("statuscol").setup {
      ft_ignore = { "neo-tree", "dashboard" },
      relculright = true,
      foldfunc = "builtin",
      setopt = true,
      segments = {
        -- Folds
        {
          text = { builtin.foldfunc },
        },
        -- Relative Line Numbers
        {
          text = { " ", builtin.lnumfunc, maxwidth = 2, " " },
          condition = { true, builtin.not_empty },
        },
        -- Gitsigns
        {
          sign = {
            namespace = { "gitsigns" },
            maxwidth = 1,
            colwidth = 1,
            wrap = true,
          },
        },
        -- Diagnostics
        {
          sign = { name = { "Diagnostic" }, maxwidth = 1, auto = true },
          click = "v:lua.ScSa",
        },
        {
          sign = { name = { "DapBreakpoint" }, maxwidth = 1, auto = false, "  " },
          click = "v:lua.dap.toggle_breakpoint",
        },
      },
    }
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local icon = require("core.assets").getIcon("ui", "Folded")
      local newVirtText = {}
      local totalLines = vim.api.nvim_buf_line_count(0)
      local foldedLines = endLnum - lnum
      local suffix = ("  ...   " .. icon .. " %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
      suffix = (" "):rep(rAlignAppndx) .. suffix
      table.insert(newVirtText, { suffix, "MoreMsg" })
      return newVirtText
    end
    opts["fold_virt_text_handler"] = handler
    require("ufo").setup(opts)
    -- Customizing fold text barline
    maps.n["zR"] = { ufo.openAllFolds, { desc = get_icon("ui", "FoldsOpen", 2) .. "open all folds" } }
    maps.n["zM"] = { ufo.closeAllFolds, { desc = get_icon("ui", "FoldsClose", 2) .. "close all folds" } }
    maps.n["zr"] = { ufo.openFoldsExceptKinds, { desc = "folds all exvept kinds" } }
  end,
}
