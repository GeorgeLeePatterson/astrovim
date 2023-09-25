local M = {}
local a_utils = require "astronvim.utils"
local user_config = require "user.config"

--
-- LSP Helpers
--
function M.lsp_on_attach(client, bufnr)
  -- Attach nvim-navic if installed
  if a_utils.is_available "nvim-navic" then
    if client.server_capabilities.documentSymbolProvider then
      local nvim_navic_avail, nvim_navic = pcall(require, "nvim_navic")
      if nvim_navic_avail then nvim_navic.attach(client, bufnr) end
    end
  end
end

--
-- Theme Helpers
--
function M.get_background_mode() return vim.api.nvim_get_option "background" end
function M.set_background_and_theme(bg, theme)
  local cur_mode = M.get_background_mode()

  local default_mode = user_config.defaults.background
  bg = bg or default_mode

  if theme then
    local default_theme = user_config.defaults.theme[bg]
    theme = theme or default_theme
    -- Change color scheme
    vim.cmd.colorscheme(theme)
    vim.notify("Changed theme to " .. theme, vim.log.levels.INFO)
  end

  -- Change background mode
  if cur_mode ~= bg then vim.o.background = bg end
  vim.notify("Changed mode from " .. cur_mode .. " to " .. bg)

  -- Reload bufferline
  if a_utils.is_available "bufferline" then
    vim.schedule(function() require("bufferline").setup(user_config.bufferline) end)
  end
end

--
-- Highlight helpers
--
function M.set_hl(hl_name, opts, hl_def)
  hl_def = hl_def or {}
  for k, v in pairs(opts) do
    hl_def[k] = v
  end
  vim.api.nvim_set_hl(0, hl_name, hl_def)
end

-- Due to the way different colorschemes configure different highlights group,
-- there is no universal way to add gui options to all the desired components.
-- Findout the final highlight group being linked to and update gui option.
function M.mod_hl(hl_name, opts)
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl_by_name, hl_name, true)
  if is_ok then M.set_hl(hl_name, opts, hl_def) end
end

--
-- String helpers
--
function M.str_contains(haystack, needle) return string.find(haystack, needle, 1, true) ~= nil end

function M.str_startswith(start) return string.sub(1, #start) == start end

function M.str_endswith(str, ending) return ending == "" or string.sub(str, -#ending) == ending end

function M.str_replace(old, new)
  local search_start_idx = 1

  local s = old
  while true do
    local start_idx, end_idx = string.find(old, new, search_start_idx, true)
    if not start_idx then break end

    local postfix = s:sub(end_idx + 1)
    s = s:sub(1, (start_idx - 1)) .. new .. postfix

    search_start_idx = -1 * postfix:len()
  end

  return s
end

function M.str_insert(str, pos, text) return string.sub(str, 1, pos - 1) .. text .. string.sub(str, pos) end

--
-- Utility functions
--

function M.random_gen(list)
  math.randomseed(os.time())
  return list[math.random(1, #list)]
end

return M
