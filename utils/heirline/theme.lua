local heirline = require "heirline.utils"
local util = require "user.utils.heirline.util"
local get_hl = heirline.get_highlight

local horizon_palette = require("horizon.palette-dark").palette
local horizon_colors = {}
for key, color in pairs(horizon_palette) do
  if key == "ansi" then color = color["bright"] end
  for name, hex in pairs(color) do
    horizon_colors[name] = hex
  end
end

local M = {} -- theme

local colors
do
  colors = {}

  for key, color in pairs(horizon_colors) do
    colors[key] = color
  end

  colors.fg1 = "#f0dec2"
  colors.grey3 = "#b0a392"
  colors.dark = "#282828"
  colors.black = "#141414"
  colors.blue2 = "#64af9c"
  colors.status_accent = "#98c369"

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
  StatusLineDarker = { bg = colors.black },
  StatusLineAccent = { fg = colors.dark, bg = colors.status_accent },
  StatusLineAccentLsp = function(lsp) return { fg = colors.dark, bg = M.lsp_colors[lsp] } end,

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

-- Mode colors
do
  local mode_colors = {
    normal = colors.gray1,
    op = colors.blue,
    insert = colors.blue,
    visual = colors.yellow,
    visual_lines = colors.apricot,
    visual_block = colors.apricot,
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
        fg = "bg", -- hl.StatusLine.bg,
        bg = mode_colors[mode],
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
  marksmen = "#f173b7",
  lua_ls = "#5EBCF6",
  stylua = "#5EBCF6",
  taplo = "#43BF6C",
  ansiblels = "#ffffff",
  copilot = "#ff5170",
  none = colors.status_accent,
}
M.lsp_colors = util.create_metatable(lsp_colors, {}, "none")

-- Configure accent based on lsp_colors above
M.lsp_server_accent = function(lsps)
  local accent = lsp_colors["none"]
  for _, lsp in ipairs(lsps or {}) do
    if lsp ~= "null-ls" then
      local found = lsp_colors[lsp]
      if found then
        accent = found
        break
      end
    end
  end
  return { fg = hl.StatusLineAccent.fg, bg = accent }
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
