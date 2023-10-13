local heirline = require "heirline.utils"
local astro_status = require "astronvim.utils.status"
local util = {}

util.diagnostics = { "errors", "warnings", "info", "hints" }

util.icons = {
  powerline = {
    -- 
    vertical_bar_thin = "│",
    vertical_bar = "┃",
    block = "█",
    ----------------------------------------------
    left = "",
    left_filled = "",
    right = "",
    right_filled = "",
    ----------------------------------------------
    slant_left = "",
    slant_left_thin = "",
    slant_right = "",
    slant_right_thin = "",
    ----------------------------------------------
    slant_left_2 = "",
    slant_left_2_thin = "",
    slant_right_2 = "",
    slant_right_2_thin = "",
    ----------------------------------------------
    left_rounded = "",
    left_rounded_thin = "",
    right_rounded = "",
    right_rounded_thin = "",
    ----------------------------------------------
    trapezoid_left = "",
    trapezoid_right = "",
    ----------------------------------------------
    line_number = "",
    column_number = "",
  },
  padlock = "",
  circle_small = "●", -- ●
  circle = "", -- 
  circle_plus = "", -- 
  dot_circle_o = "", -- 
  circle_o = "⭘", -- ⭘

  pacman = "󰊠",
}

util.mode = setmetatable({
  ["n"] = "normal",
  ["no"] = "op",
  ["nov"] = "op",
  ["noV"] = "op",
  ["no"] = "op",
  ["niI"] = "normal",
  ["niR"] = "normal",
  ["niV"] = "normal",
  ["v"] = "visual",
  ["vs"] = "visual",
  ["V"] = "visual_lines",
  ["Vs"] = "visual_lines",
  [""] = "visual_block",
  [" "] = "visual_block",
  [" s"] = "visual_block",
  ["s"] = "select",
  ["S"] = "select",
  [""] = "block",
  ["i"] = "insert",
  ["ic"] = "insert",
  ["ix"] = "insert",
  ["R"] = "replace",
  ["Rc"] = "replace",
  ["Rv"] = "v_replace",
  ["Rx"] = "replace",
  ["c"] = "command",
  ["cv"] = "command",
  ["ce"] = "command",
  ["r"] = "enter",
  ["rm"] = "more",
  ["r?"] = "confirm",
  ["!"] = "shell",
  ["t"] = "terminal",
  ["nt"] = "terminal",
  ["null"] = "none",
}, {
  __call = function(self, raw_mode) return self[raw_mode] end,
})

util.get_mode = function(mode)
  local m = util.mode[mode]
  return m or util.mode["null"]
end

util.mode_label = {
  normal = "NORMAL",
  op = "OP",
  visual = "VISUAL",
  visual_lines = "VISUAL LINES",
  visual_block = "VISUAL BLOCK",
  select = "SELECT",
  block = "BLOCK",
  insert = "INSERT",
  replace = "REPLACE",
  v_replace = "V-REPLACE",
  command = "COMMAND",
  enter = "ENTER",
  more = "MORE",
  confirm = "CONFIRM",
  shell = "SHELL",
  terminal = "TERMINAL",
  none = "NONE",
}

util.IconProvider = function(ico, opts)
  local provider = opts or {}
  provider.provider = ico
  return provider
end

util.add_provider = function(current, n) table.insert(current, n) end
util.merge_providers = function(current, n) return vim.list_extend(current, n) end

-- Simple utility to merge simple icon providers
util.merge_icon_providers = function(providers)
  if not providers or #providers == 0 then return providers end
  local icons = {}
  for _, provider in ipairs(providers) do
    if provider.provider and type(provider.provider) == "string" then table.insert(icons, provider.provider) end
  end

  return table.concat(icons, "")
end

-- Simple utility to create icon providers as strings and/or tables
util.create_icon_provider = function(icons, opts)
  if not icons or #icons == 0 then return {} end
  local providers = {}
  for _, icon in ipairs(icons) do
    if type(icon) == "string" then
      table.insert(providers, util.IconProvider(icon))
    else
      table.insert(providers, icon)
    end
  end
  local merged = util.merge_icon_providers(providers)
  return vim.tbl_deep_extend("force", { provider = merged }, opts or {})
end

-- Simple check for code type files
function util.is_file() return vim.bo.buftype == "" end

-- Utility functions for overloading
util.create_metatable = function(default, opts, default_key, no_index)
  default = default or {}
  default = vim.tbl_deep_extend("force", default, opts or {})
  return setmetatable(default, {
    __call = function(_, o)
      o = o or {}
      return vim.tbl_deep_extend("force", default, o)
    end,
    __index = no_index and nil or function(_, key) return (default or {})[key] or (default or {})[default_key] end,
  })
end

-- Create callout sections in the statusline, to stand out from theme supplied colors
-- @param component component to surround
-- @param options? specify surround delimiters and hl colors
-- @param opts? heirline opts
-- @return heirline component surrounded
util.CalloutSection = function(component, options)
  options = options or {}
  local surround = options["surround"] or {}
  if #surround == 0 then return component end

  local hl = options["hl"]
  local left = options["left"]
  local right = options["right"]
  local condition = options["condition"]

  if #surround == 0 then return component end

  if left or right then
    local colors = function(self)
      local l = type(left) == "function" and left(self) or left
      local r = type(right) == "function" and right(self) or right
      local h = type(hl) == "function" and hl(self) or hl
      return { main = h, left = l, right = r }
    end

    return astro_status.utils.surround(surround, colors, component or { provider = "" }, condition)
  end

  return heirline.surround(surround, function() -- color
    return type(hl) == "function" and hl() or hl
  end, component or { provider = "" })
end

return util
