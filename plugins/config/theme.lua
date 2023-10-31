local user_utils = require "user.utils"
local colors_ok, colors = pcall(require, "user.utils.colors")
local cs_config = require("user.config").colorscheme or {}

local fave_theme_mds = {}
for _, v in ipairs(cs_config.favorite_themes) do
  if type(v) == "table" then
    for _, _v in ipairs(v) do
      table.insert(fave_theme_mds, _v)
    end
  else
    table.insert(fave_theme_mds, v)
  end
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

-- [[Theme specific config]]

M.common_styles = {
  comments = "italic",
  keywords = "bold",
  types = "italic,bold",
}

M.theme_opts = {
  onedark = {
    style = "darker",
    toggle_style_key = "<leader>mt",
    code_style = M.common_styles,
  },
}

M.mappings = function(mappings)
  -- Onedark helpers
  local onedark = require "onedark"
  local onedark_load = function(variant, opts)
    opts = opts or {}
    opts.style = variant or "dark"
    onedark.setup(vim.tbl_deep_extend("force", M.theme_opts.onedark, opts) or M.theme_opts.onedark)
    onedark.load()
  end

  mappings["n"]["<leader>m"] = { name = " Themes" }

  -- Various themes
  local various = {
    { function() vim.cmd [[colorscheme midnight]] end, desc = "Midnight" },
    { function() vim.cmd [[colorscheme oxocarbon]] end, desc = "Oxocarbon" },
    { function() vim.cmd [[colorscheme Tokyodark]] end, desc = "TokyoDark" },
    { function() vim.cmd [[colorscheme gruvbox]] end, desc = "Gruvbox" },
    { function() vim.cmd [[colorscheme gruvbox-material]] end, desc = "Gruvbox Material" },
    -- { function() vim.cmd [[colorscheme horizon]] end, desc = "Horizon" }, -- Currently bug with light theme.
  }

  for k, v in ipairs(various) do
    mappings["n"]["<leader>m" .. k + 1] = v
  end

  mappings["n"] = vim.tbl_deep_extend("force", mappings["n"], {
    -- Monokai
    ["<leader>ma"] = { name = "Monokai" },
    ["<leader>ma0"] = { function() vim.cmd [[colorscheme monokai-pro-default]] end, desc = "Default" },
    ["<leader>ma1"] = { function() vim.cmd [[colorscheme monokai-pro-classic]] end, desc = "Classic" },
    ["<leader>ma2"] = { function() vim.cmd [[colorscheme monokai-pro-machine]] end, desc = "Machine" },
    ["<leader>ma3"] = { function() vim.cmd [[colorscheme monokai-pro-octagon]] end, desc = "Octagon" },
    ["<leader>ma4"] = { function() vim.cmd [[colorscheme monokai-pro-spectrum]] end, desc = "Spectrum" },
    ["<leader>ma5"] = { function() vim.cmd [[colorscheme monokai-pro-ristretto]] end, desc = "Ristretto" },
    -- TokyoNight
    ["<leader>ms"] = { name = "TokyoNight" },
    ["<leader>ms0"] = { function() vim.cmd [[colorscheme tokyonight]] end, desc = "Default" },
    ["<leader>ms1"] = { function() vim.cmd [[colorscheme tokyonight-day]] end, desc = "Day" },
    ["<leader>ms2"] = { function() vim.cmd [[colorscheme tokyonight-moon]] end, desc = "Moon" },
    ["<leader>ms3"] = { function() vim.cmd [[colorscheme tokyonight-night]] end, desc = "NightNight" },
    ["<leader>ms4"] = { function() vim.cmd [[colorscheme tokyonight-storm]] end, desc = "Storm" },
    -- Catppuccin
    ["<leader>md"] = { name = "Catppuccin" },
    ["<leader>md0"] = { function() vim.cmd [[colorscheme catppuccin-latte]] end, desc = "Latte" },
    ["<leader>md1"] = { function() vim.cmd [[colorscheme catppuccin-frappe]] end, desc = "Frappe" },
    ["<leader>md2"] = { function() vim.cmd [[colorscheme catppuccin-macchiato]] end, desc = "Macchiato" },
    ["<leader>md3"] = { function() vim.cmd [[colorscheme catppuccin-mocha]] end, desc = "Mocha" },
    -- Github
    ["<leader>mf"] = { name = "Github" },
    ["<leader>mf0"] = { function() vim.cmd [[colorscheme github_dark]] end, desc = "Dark" },
    ["<leader>mf1"] = {
      function() vim.cmd [[colorscheme github_dark_dimmed]] end,
      desc = "Dark Dimmed",
    },
    ["<leader>mf2"] = {
      function() vim.cmd [[colorscheme github_dark_high_contrast]] end,
      desc = "Dark High Contrast",
    },
    ["<leader>mf3"] = { function() vim.cmd [[colorscheme github_light]] end, desc = "Light" },
    ["<leader>mf4"] = {
      function() vim.cmd [[colorscheme github_light_high_contrast]] end,
      desc = "Light High Contrast",
    },
    -- Nightfox
    ["<leader>mj"] = { name = "Nightfox" },
    ["<leader>mj0"] = { function() vim.cmd [[colorscheme nightfox]] end, desc = "Nightfox" },
    ["<leader>mj1"] = { function() vim.cmd [[colorscheme dayfox]] end, desc = "Dayfox (light)" },
    ["<leader>mj2"] = { function() vim.cmd [[colorscheme dawnfox]] end, desc = "Dawnfox (light)" },
    ["<leader>mj3"] = { function() vim.cmd [[colorscheme duskfox]] end, desc = "Duskfox" },
    ["<leader>mj4"] = { function() vim.cmd [[colorscheme nordfox]] end, desc = "Nordfox" },
    ["<leader>mj5"] = { function() vim.cmd [[colorscheme terafox]] end, desc = "Terafox" },
    ["<leader>mj6"] = { function() vim.cmd [[colorscheme carbonfox]] end, desc = "Carbonfox" },
    -- Bluloco
    ["<leader>mk"] = { name = "Bluloco" },
    ["<leader>mk0"] = { function() vim.cmd [[colorscheme bluloco]] end, desc = "Bluloco" },
    ["<leader>mk1"] = { function() vim.cmd [[colorscheme bluloco-dark]] end, desc = "Bluloco (dark)" },
    ["<leader>mk2"] = { function() vim.cmd [[colorscheme bluloco-light]] end, desc = "Bluloco (light)" },
    -- OneDark
    ["<leader>ml"] = { name = "OneDark" },
    ["<leader>ml0"] = { function() onedark_load "dark" end, desc = "Default (dark)" },
    ["<leader>ml1"] = { function() onedark_load "darker" end, desc = "Darker" },
    ["<leader>ml2"] = { function() onedark_load "cool" end, desc = "Cool" },
    ["<leader>ml3"] = { function() onedark_load "deep" end, desc = "Deep" },
    ["<leader>ml4"] = { function() onedark_load "warm" end, desc = "Warm" },
    ["<leader>ml5"] = { function() onedark_load "warmer" end, desc = "Warmer" },
    ["<leader>ml6"] = { function() onedark_load "light" end, desc = "Light" },
    ["<leader>mlt"] = { function() onedark.toggle() end, desc = "Toggle" },
    -- Mellifluous
    ["<leader>m;"] = { name = "Mellifluous" },
    ["<leader>m;0"] = { function() vim.cmd [[colorscheme mellifluous]] end, desc = "Default" },
  })
  return mappings
end

return M
