local heirline = require "heirline.utils"
local util = require "user.utils.heirline.util"
local get_hl = heirline.get_highlight

local horizon_palette = require("horizon.palette-dark").palette
local horizon_colors = {}
for key, color in pairs(horizon_palette) do
  for name, hex in pairs(color) do
    if type(hex) == "string" then
      if horizon_colors[name] then
        horizon_colors[key .. name] = hex
      else
        horizon_colors[name] = hex
      end
    elseif type(hex) == "table" then
      for mode, variation in pairs(hex) do
        if type(variation) == "string" then
          if horizon_colors[mode] then
            horizon_colors[name .. mode] = variation
          else
            horizon_colors[mode] = variation
          end
        end
      end
    end
  end
end

local M = {} -- theme

local colors
do
  colors = {}

  for key, color in pairs(horizon_colors) do
    colors[key] = color
  end

  colors.apricot2 = "#DB887A"
  colors.background_alt = colors.gray -- colors.background_alt or "#404040"
  colors.black = "#141414"
  colors.blue2 = "#64af9c"
  colors.dark = "#282828"
  colors.fg1 = "#f0dec2"
  colors.grey3 = "#b0a392"
  colors.status_accent = "#99c369"

  colors.onedark = {
    blue = "#8ab7d8",
    green = "#98c369",
    yellow = "#ffff70",
    orange = "#ea9d70",
    purple = "#c475c1",
    red = "#971717",
  }
end

M.colors = colors

local hl = {
  StatusLine = get_hl "Statusline",
  StatusLineDark = { bg = colors.dark },
  StatusLineDarkFg = { fg = colors.lightText },

  StatusLineDarker = { bg = colors.black },

  StatusLineAccent = { fg = colors.dark, bg = colors.status_accent },

  StatusLineLight = { bg = colors.background_alt },
  StatusLineLightFg = { fg = colors.darkText },

  ReadOnly = { fg = colors.red },

  WorkDir = { fg = colors.grey3, bold = true },

  CurrentPath = { fg = get_hl("Directory").fg, bold = true },

  FileName = { fg = get_hl("Statusline").fg, bold = true },

  FileProperties = nil,

  DapMessages = { fg = get_hl("Debug").fg },

  Git = {
    branch = { fg = colors.purple, bold = true },
    added = { fg = colors.green, bold = true },
    changed = { fg = colors.yellow, bold = true },
    removed = { fg = colors.red, bold = true },
    dirty = { fg = colors.grey2, bold = true },
  },

  LspIndicator = { fg = colors.blue },
  LspServer = { fg = colors.onedark.blue, bold = true },

  Diagnostic = {
    errors = { fg = get_hl("DiagnosticSignError").fg },
    warnings = { fg = get_hl("DiagnosticSignWarn").fg },
    info = { fg = get_hl("DiagnosticSignInfo").fg },
    hints = { fg = get_hl("DiagnosticSignHint").fg },
  },

  ScrollBar = { bg = colors.grey0, fg = colors.fg1 },

  SearchResults = { fg = colors.dark, bg = colors.aqua },

  WinBar = get_hl "WinBar",

  Navic = { Separator = { fg = colors.grey1 } },
}
M.highlight = hl

-- Get the proper bg/fg for a light/dark colorscheme
-- @param boolean whether to include fg color
-- @return table
M.get_callout_hl = function(fg)
  local callout_hl = "StatusLineDark"
  local is_dark = true
  local ok, bg = pcall(function() return vim.g.colorscheme_bg end)
  if ok then
    if bg ~= nil then is_dark = (bg == "dark") end -- user_colors.theme_info()["is_dark"]
  end

  if not is_dark then callout_hl = "StatusLineLight" end

  local highlight = hl[callout_hl]
  if fg then highlight["fg"] = hl[callout_hl .. "Fg"]["fg"] end

  return { bg = highlight and highlight["bg"] or nil, fg = highlight and highlight["fg"] or nil }
end

-- Mode colors
do
  local mode_colors = {
    normal = colors.gray,
    op = colors.blue,
    insert = colors.blue,
    visual = colors.yellow,
    visual_lines = colors.apricot,
    visual_block = colors.apricot2,
    replace = colors.red,
    v_replace = colors.red,
    enter = colors.orange,
    more = colors.orange,
    select = colors.red2,
    command = colors.green,
    shell = colors.purple,
    term = colors.purple,
    none = colors.orange,
  }

  hl.Mode = setmetatable({
    normal = { fg = mode_colors.normal },
  }, {
    __index = function(_, mode)
      return {
        -- fg = colors.black,
        fg = hl.StatusLine.bg,
        bg = mode_colors[mode] or mode_colors["none"],
        bold = true,
      }
    end,
  })
end

-- hydra: TODO
do
  -- #008080
  -- #00a4a4
  -- #00aeae

  -- #f2594b
  -- #f36c62

  -- #ff1757
  -- #ff476b
  -- #ff5170

  -- #f063b2
  -- #f173b7

  M.hydra = {
    red = "#f36c62",
    amaranth = "#ff5170",
    teal = "#00aeae",
    pink = "#f173b7",
  }
end

local lsp_colors = {
  rust_analyzer = "#f36c62",
  tsserver = "#00aeae",
  marksman = "#f173b7",
  lua_ls = "#5EBCF6",
  stylua = "#5EBCF6",
  taplo = "#43BF6C",
  ansiblels = "#ffffff",
  copilot = "#ff5170",
  none = colors.status_accent,
}
local lsp_rank = { rust_analyzer = 1, tsserver = 2, marksman = 3, lua_ls = 4, stylelua = 5 }
M.lsp_colors = util.create_metatable(lsp_colors, {}, "none")

local lsp_accents = {
  default = { fg = hl.StatusLineAccent.fg, bg = lsp_colors["none"] },
}

-- Configure accent based on lsp_colors above
M.lsp_server_accent = function(lsps)
  local accent = nil
  local key = table.concat(lsps)
  if lsps and #lsps > 0 then
    if lsp_accents[key] then return lsp_accents[key] end
    local current_rank = -1
    for _, lsp_name in pairs(lsps) do
      local found = lsp_colors[lsp_name]
      if found then
        local rank = lsp_rank[lsp_name] or 0
        if rank > current_rank then
          accent = found
          current_rank = rank
        end
      end
    end
  end

  if accent then
    local accent_hl = { fg = hl.StatusLineAccent.fg, bg = accent }
    lsp_accents[key] = accent_hl
    return accent_hl
  else
    lsp_accents[key] = lsp_accents.default
    return lsp_accents.default
  end
end

-- Configure surrounds for astronvim based on lsp server
M.lsp_server_surround = function(lsps, inc)
  if not inc or #inc == 0 then inc = { "main" } end
  local highlight = M.lsp_server_accent(lsps)
  local surround = {}
  for _, key in ipairs(inc) do
    surround[key] = highlight.bg
  end
  return surround
end

return M

-- Horizon colors

-- local palette = {
--   ansi = {
--     bright = {
--       blue = '#3FC4DE',
--       cyan = '#6BE4E6',
--       green = '#3FDAA4',
--       magenta = '#F075B5',
--       red = '#EC6A88',
--       yellow = '#FBC3A7',
--     },
--     normal = {
--       blue = '#26BBD9',
--       cyan = '#59E1E3',
--       green = '#29D398',
--       magenta = '#EE64AC',
--       red = '#E95678',
--       yellow = '#FAB795',
--     },
--   },
--   syntax = {
--     apricot = '#F09483',

--     cranberry = '#E95678',
--     gray = '#BBBBBB',
--     lavender = '#B877DB',
--     rosebud = '#FAB795',
--     tacao = '#FAC29A',
--     turquoise = '#25B0BC',
--   },
--   ui = {
--     accent = '#2E303E',
--     accentAlt = '#6C6F93',
--     background = '#1C1E26',
--     backgroundAlt = '#232530',
--     border = '#1A1C23',
--     darkText = '#06060C',
--     lightText = '#D5D8DA',
--     modified = '#21BFC2',
--     negative = '#F43E5C',
--     positive = '#09F7A0',
--     secondaryAccent = '#E9436D',
--     secondaryAccentAlt = '#E95378',
--     shadow = '#16161C',
--     tertiaryAccent = '#FAB38E',
--     warning = '#27D797',
--   },
-- }
--
-- local theme = {
--   active_line_number_fg = '#797B80',
--   bg = '#1C1E26',
--   class_variable = {
--     fg = '#D55070',
--   },
--   code_block = {
--     fg = '#DB887A',
--   },
--   codelens_fg = '#44475D',
--   color_column_fg = '#343647',
--   comment = {
--     fg = '#4C4D53',
--     italic = true,
--   },
--   constant = {
--     fg = '#DB887A',
--   },
--   cursor_bg = '#E95378',
--   cursor_fg = '#1C1E26',
--   cursorline_bg = '#21232D',
--   delimiter = {
--     fg = '#6C6D71',
--   },
--   diff_added_bg = '#1A3432',
--   diff_deleted_bg = '#4A2024',
--   error = '#F43E5C',
--   external_link = '#E9436D',
--   fg = '#BBBBBB',
--   field = {
--     fg = '#D55070',
--   },
--   float_bg = '#232530',
--   float_border = '#232530',
--   func = {
--     fg = '#24A1AD',
--   },
--   git_added_fg = '#24A075',
--   git_deleted_fg = '#F43E5C',
--   git_ignored_fg = '#54565C',
--   git_modified_fg = '#FAB38E',
--   git_untracked_fg = '#27D797',
--   inactive_line_number_fg = '#2F3138',
--   indent_guide_active_fg = '#2E303E',
--   indent_guide_fg = '#252732',
--   keyword = {
--     fg = '#A86EC9',
--   },
--   link = {
--     fg = '#E4A88A',
--   },
--   match_paren = '#44475D',
--   operator = {
--     fg = '#BBBBBB',
--   },
--   parameter = {
--     italic = true,
--   },
--   pmenu_bg = '#232530',
--   pmenu_item_sel_fg = '#E95378',
--   pmenu_thumb_bg = '#242631',
--   pmenu_thumb_fg = '#44475D',
--   regex = {
--     fg = '#DB887A',
--   },
--   sidebar_bg = '#1C1E26',
--   sidebar_fg = '#797B80',
--   sign_added_bg = '#0FB67B',
--   sign_deleted_bg = '#B3344C',
--   sign_modified_bg = '#208F93',
--   special_keyword = {
--     fg = '#A86EC9',
--   },
--   statusline_active_fg = '#2E303E',
--   statusline_bg = '#1C1E26',
--   statusline_fg = '#797B80',
--   storage = {
--     fg = '#A86EC9',
--   },
--   string = {
--     fg = '#E4A88A',
--   },
--   structure = {
--     fg = '#E4B28E',
--   },
--   tag = {
--     fg = '#D55070',
--     italic = true,
--   },
--   template_delimiter = {
--     fg = '#A86EC9',
--   },
--   term_cursor_bg = '#D5D8DA',
--   term_cursor_fg = '#44475D',
--   title = {
--     fg = '#D55070',
--   },
--   type = {
--     fg = '#E4B28E',
--   },
--   variable = {
--     fg = '#D55070',
--   },
--   visual = '#343647',
--   warning = '#24A075',
--   winbar = '#232530',
--   winseparator_fg = '#1A1C23',
-- }
