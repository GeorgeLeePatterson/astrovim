local user_utils = require "user.utils"
local favorites = require("user.config").favorite_themes

local fave_theme_mds = {}
for k in pairs(favorites) do
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

return M
