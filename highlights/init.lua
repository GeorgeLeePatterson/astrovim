local get_hlgroup = require("astronvim.utils").get_hlgroup
local custom_colors = require "user.utils.colors"

-- get highlights from highlight groups
local normal = get_hlgroup "Pmenu"
local fg, bg = normal.fg, normal.bg
local bg_alt = get_hlgroup("Visual").bg
local green = get_hlgroup("String").fg
local red = get_hlgroup("Error").fg

local custom_highlights = { -- this table overrides highlights in all themes
  PmenuSel = { bg = "#282C34", fg = "NONE" },
  Pmenu = { bg = "NONE", fg = "NONE" },

  FloatBorder = { fg = "#3774B4", bg = "NONE" },

  -- nvim-cmp menu overrides

  -- Custom border with transparent bg
  BorderOnly = { fg = "#3774B4", bg = "None" },

  CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true },
  CmpItemAbbrMatch = { fg = "#FB4374", bg = "NONE", bold = true },
  CmpItemAbbrMatchFuzzy = { fg = "#FB4374", bg = "NONE", bold = true },
  CmpItemMenu = { italic = true },

  CmpItemKindField = { fg = "#B5585F" },
  CmpItemKindProperty = { fg = "#B5585F" },
  CmpItemKindEvent = { fg = "#B5585F" },

  CmpItemKindText = { fg = "#C3E88D" },
  CmpItemKindEnum = { fg = "#C3E88D" },
  CmpItemKindKeyword = { fg = "#C3E88D" },

  CmpItemKindConstant = { fg = "#FFE082" },
  CmpItemKindConstructor = { fg = "#FFE082" },
  CmpItemKindReference = { fg = "#FFE082" },

  CmpItemKindFunction = { fg = "#A377BF" },
  CmpItemKindStruct = { fg = "#A377BF" },
  CmpItemKindClass = { fg = "#A377BF" },
  CmpItemKindModule = { fg = "#A377BF" },
  CmpItemKindOperator = { fg = "#A377BF" },

  -- CmpItemKindVariable = { fg = "#C5CDD9", bg = "#7E8294" },
  -- CmpItemKindFile = { fg = "#C5CDD9", bg = "#7E8294" },

  CmpItemKindUnit = { fg = "#D4A959" },
  CmpItemKindSnippet = { fg = "#D4A959" },
  CmpItemKindFolder = { fg = "#D4A959" },

  CmpItemKindMethod = { fg = "#6C8ED4" },
  CmpItemKindValue = { fg = "#6C8ED4" },
  CmpItemKindEnumMember = { fg = "#6C8ED4" },

  CmpItemKindInterface = { fg = "#58B5A8" },
  CmpItemKindColor = { fg = "#58B5A8" },
  CmpItemKindTypeParameter = { fg = "#58B5A8" },

  CmpItemKindCopilot = { fg = "#6CC644" },

  -- Telescope overrides
  TelescopeBorder = { fg = "#3774B4", bg = "None" }, -- { fg = bg_alt, bg = bg },
  -- TelescopeNormal = { bg = bg },
  TelescopePreviewBorder = { fg = bg, bg = bg },
  TelescopePreviewNormal = { bg = bg },
  TelescopePreviewTitle = { fg = bg, bg = green },
  TelescopePromptBorder = { fg = bg_alt, bg = bg_alt },
  TelescopePromptNormal = { fg = fg, bg = bg_alt },
  TelescopePromptPrefix = { fg = red, bg = bg_alt },
  TelescopePromptTitle = { bg = "#3774B4", fg = "#FFFFFF" }, -- { fg = bg },
  TelescopeResultsBorder = { fg = bg, bg = bg },
  TelescopeResultsNormal = { bg = bg },
  TelescopeResultsTitle = { fg = bg, bg = bg },

  -- Dashboard colors
  StartLogo1 = { ctermfg = 126, fg = "#c2185b", default = true },
  StartLogo2 = { ctermfg = 126, fg = "#c51162", default = true },
  StartLogo3 = { ctermfg = 126, fg = "#880e4f", default = true },
  StartLogo4 = { ctermfg = 5, fg = "#ba68c8", default = true },
  StartLogo5 = { ctermfg = 5, fg = "#ab47bc", default = true },
  StartLogo6 = { ctermfg = 5, fg = "#9c27b0", default = true },
  StartLogo7 = { ctermfg = 5, fg = "#7b1fa2", default = true },
  StartLogo8 = { ctermfg = 5, fg = "#6a1b9a", default = true },
  StartLogo9 = { ctermfg = 18, fg = "#651fff", default = true },
  StartLogo10 = { ctermfg = 18, fg = "#3f51b5", default = true },
  StartLogo11 = { ctermfg = 18, fg = "#0d47a1", default = true },
  StartLogo12 = { ctermfg = 18, fg = "#303f9f", default = true },
  StartLogo13 = { ctermfg = 18, fg = "#283593", default = true },
  StartLogo14 = { ctermfg = 18, fg = "#1a237e", default = true },
  StartLogo15 = { ctermfg = 23, fg = "#00b8d4", default = true },
  StartLogo16 = { ctermfg = 23, fg = "#0097a7", default = true },
  StartLogo17 = { ctermfg = 23, fg = "#009688", default = true },
  StartLogo18 = { ctermfg = 29, fg = "#00796b", default = true },
  StartLogo19 = { ctermfg = 29, fg = "#00695c", default = true },
  StartLogo20 = { ctermfg = 35, fg = "#004d40", default = true },
  StartLogo21 = { ctermfg = 35, fg = "#006064", default = true },
  StartLogo22 = { ctermfg = 35, fg = "#2e7d32", default = true },
  StartLogo23 = { ctermfg = 41, fg = "#33691e", default = true },
  StartLogo24 = { ctermfg = 41, fg = "#1b5e20", default = true },
  StartLogo25 = { ctermfg = 41, fg = "#689f38", default = true },
  StartLogo26 = { ctermfg = 41, fg = "#558b2f", default = true },
  StartLogo27 = { ctermfg = 47, fg = "#b2ff59", default = true },
  StartLogo28 = { ctermfg = 47, fg = "#aeea00", default = true },
  StartLogo29 = { ctermfg = 154, fg = "#fff176", default = true },
  StartLogo30 = { ctermfg = 154, fg = "#ffee58", default = true },
  StartLogo31 = { ctermfg = 190, fg = "#ffff8d", default = true },
  StartLogo32 = { ctermfg = 190, fg = "#ffff00", default = true },
  StartLogo33 = { ctermfg = 190, fg = "#ffea00", default = true },
  StartLogo34 = { ctermfg = 190, fg = "#ffeb3b", default = true },
  StartLogoPop1 = { ctermfg = 214, fg = "#EC9F05", default = true },
  StartLogoPop2 = { ctermfg = 208, fg = "#F08C04", default = true },
  StartLogoPop3 = { ctermfg = 208, fg = "#F37E03", default = true },
  StartLogoPop4 = { ctermfg = 202, fg = "#F77002", default = true },
  StartLogoPop5 = { ctermfg = 202, fg = "#FB5D01", default = true },
  StartLogoPop6 = { ctermfg = 202, fg = "#FF4E00", default = true },
}

local color_highlights = custom_colors.generate_hls()
custom_highlights = vim.tbl_extend("force", custom_highlights, color_highlights)

return custom_highlights
