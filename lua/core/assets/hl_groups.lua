vim.cmd [[
highlight! link CmpNormal NormalFloat
highlight! link CmpBorder FloatBorder
highlight! link CmpCursorLine Visual
highlight! link CmpDocNormal NormalFloat
highlight! link CmpDocBorder FloatBorder
]]

vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

vim.api.nvim_set_hl(0, "MarkSignHL", { fg = "#C792EA", bg = "#3c3836" })
