---@diagnostic disable: duplicate-set-field

------------------------
--- global functions ---
------------------------
_G.P = function(...)
  local msg = vim.inspect(...)
  vim.notify(msg, "info", {
    on_open = function(win)
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, "lua")
    end,
  })
end

_G.R = function(pkg_name)
  require("plenary.reload").reload_module(pkg_name)
  return require(pkg_name)
end

local M = {}
local a_utils = require "astronvim.utils"
local user_config = require "user.config"
local random = require "user.utils.random"

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

function M.str_startswith(str, start) return string.sub(str, 1, #start) == start end

function M.str_endswith(str, ending) return ending == "" or string.sub(str, -#ending) == ending end

function M.str_replace(original, old, new) return string.gsub(original, old, new) end

function M.str_insert(str, pos, text) return string.sub(str, 1, pos - 1) .. text .. string.sub(str, pos) end

function M.str_pad_len(str, total_len)
  if #str >= total_len then return str end
  return str .. string.rep(" ", total_len - #str)
end

function M.str_split(str, pat)
  local t = {} -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then table.insert(t, cap) end
    last_end = e + 1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

-- calculate the length of the longest line in a table
function M.longest_line(tbl)
  local longest = 0
  for _, v in pairs(tbl) do
    local width = vim.fn.strdisplaywidth(v)
    if width > longest then longest = width end
  end
  return longest
end

--
-- List helpers
--

function M.arr_has(arr, str)
  if not arr then return true end
  if not str then return false end
  for _, value in ipairs(arr) do
    if value == str then return true end
  end

  return false
end

--
-- Buffer functions
--

M.find_buffer_by_name = function(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if vim.endswith(buf_name, name) then return buf end
  end
  return -1
end

--
-- Utility functions
--

-- File Helpers
function M.shorten_path(path, cwd, target_width)
  local path_ok, plenary_path = pcall(require, "plenary.path")
  if not path_ok then return path end
  target_width = target_width or 35
  local short_fn = vim.fn.fnamemodify(path, ":.")
  if cwd then short_fn = vim.fn.fnamemodify(path, ":~") end
  if #short_fn > target_width then
    ---@diagnostic disable-next-line: param-type-mismatch
    local short_fn_result, err = pcall(function() return plenary_path.new(short_fn):shorten(1, { -2, -1 }) end)
    if err then return short_fn end
    if #short_fn_result > target_width then
      local short_fn_final, err_final = pcall(
        ---@diagnostic disable-next-line: param-type-mismatch
        function() return plenary_path.new(short_fn_result):shorten(1, { -1 }) end
      )
      if err_final then return short_fn_result end
      return short_fn_final
    end
  end
  return short_fn
end

function M.shorten_paths(paths, target_width)
  if not pcall(require, "plenary.path") then return paths end
  local cwd = vim.fn.getcwd()
  local tbl = {}
  for i, path in ipairs(paths) do
    tbl[i] = M.shorten_path(path, cwd, target_width)
  end
  return tbl
end

function M.git_root()
  local git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(git_path, ":h")
end

function M.create_user_command(name, fn, opts)
  vim.api.nvim_create_user_command(name, function()
    if type(fn) == "function" then
      fn()
    else
      vim.notify(vim.inspect(fn))
    end
  end, opts)
end

function M.get_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return { row = cursor[1], col = cursor[2] }
end

function M.get_visual_selection()
  local vpos = vim.fn.getpos "v"
  local begin_pos = { row = vpos[2], col = vpos[3] - 1 }
  local end_pos = M.get_cursor()
  if (begin_pos.row < end_pos.row) or ((begin_pos.row == end_pos.row) and (begin_pos.col <= end_pos.col)) then
    return { start = begin_pos, ["end"] = end_pos }
  else
    return { start = end_pos, ["end"] = begin_pos }
  end
end

-- Merge modules
M = vim.tbl_extend("force", M, random)
M = vim.tbl_extend("force", M, require "user.utils.workspace")

-- Load autocmds
require "user.utils.autocmds"

return M
