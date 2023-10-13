local user_utils = require "user.utils"
local colors_ok, colors = pcall(require, "user.utils.colors")
local cs_config = require("user.config").colorscheme or {}

local fave_theme_mds = {}
for k in pairs(cs_config.favorite_themes) do
  table.insert(fave_theme_mds, k)
end
local M = {}

M.configure_theme = function(theme, opts)
  opts = opts or {}
  if theme == nil then return {} end
  local o = { theme }
  for key, value in ipairs(opts) do
    o[key] = value
  end

  local name = theme
  if opts["name"] ~= nil then
    name = opts["name"]
  else
    local name_parts = user_utils.str_split(theme, "[\\/]+")
    if #name_parts > 0 then name = user_utils.str_replace(name_parts[#name_parts], "%.nvim", "") end
  end

  if vim.list_contains(fave_theme_mds, name) then
    o["lazy"] = false
    o["priority"] = 1000
  else
    o["event"] = o["event"] or nil
  end

  return o
end

M.configure_lush = function()
  local debug = cs_config.debug
  local get_theme_info = function()
    if colors_ok then
      local info = colors.theme_info()
      if debug then vim.notify("Theme info: " .. vim.inspect(info)) end
      return info
    else
      if debug then vim.notify "Could not get theme info" end
    end
    return {}
  end

  vim.api.nvim_create_user_command("ThemeInfo", get_theme_info, {})

  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd
  local lush_group = augroup("lush_colorscheme", { clear = true })
  autocmd("ColorScheme", {
    desc = "Test lush colorscheme changes",
    group = lush_group,
    callback = function()
      local info = get_theme_info()
      vim.g.colorscheme_bg = info["is_dark"] and "dark" or "light"
    end,
  })
end

return M
