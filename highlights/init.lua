local get_hlgroup = require("astronvim.utils").get_hlgroup
-- get highlights from highlight groups
local normal = get_hlgroup "Pmenu"
local fg, bg = normal.fg, normal.bg
local bg_alt = get_hlgroup("Visual").bg
local green = get_hlgroup("String").fg
local red = get_hlgroup("Error").fg

return { -- this table overrides highlights in all themes
  -- nvim-cmp menu overrides
  PmenuSel = { bg = "#282C34", fg = "NONE" },
  Pmenu = { bg = "NONE" },

  FloatBorder = { fg = "#3774B4", bg = "NONE" },

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
}
