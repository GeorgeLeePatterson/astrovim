local user_utils = require "user.utils"

local M = {
  categories = {
    neovim = require "user.ascii.neovim",
    gaming = require "user.ascii.gaming",
    shapes = require "user.ascii.shapes",
    misc = require "user.ascii.misc",
  },
}

M.random = function()
  local categories = M.categories

  local cat_keys = vim.tbl_keys(categories)
  cat_keys = user_utils.list_extend_rep(cat_keys, "neovim", 2)
  cat_keys = user_utils.list_extend_rep(cat_keys, "gaming", 2)

  local category = user_utils.random_gen(cat_keys)
  local name, art = user_utils.random_tbl_gen(categories[category], true)

  return category, name, art
end

M.all = {}
for _, v in pairs(M.categories) do
  if type(v) == "table" then
    if #v > 0 then vim.list_extend(M.all, v) end
  end
end

return M
