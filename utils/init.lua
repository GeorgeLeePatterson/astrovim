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

  local default_theme = user_config.defaults.theme[bg]
  theme = theme or default_theme
  -- Change color scheme
  vim.cmd.colorscheme(theme)
  vim.notify("Changed theme to " .. theme, vim.log.levels.INFO)

  -- Change background mode
  if cur_mode ~= bg then vim.o.background = bg end
  vim.notify("Changed mode from " .. cur_mode .. " to " .. bg)

  -- Reload bufferline
  if a_utils.is_available "bufferline" then
    vim.schedule(
      function() require("bufferline").setup(user_config.bufferline) end
    )
  end
end

--
-- Highlight helpers
--
function M.set_hl(hl_name, opts, hl_def, keep)
  hl_def = hl_def or {}
  for k, v in pairs(opts) do
    local should_keep = keep and hl_def[k]
    if not should_keep then hl_def[k] = v end
  end
  vim.api.nvim_set_hl(0, hl_name, hl_def)
end

-- Due to the way different colorschemes configure different highlights group,
-- there is no universal way to add gui options to all the desired components.
-- Findout the final highlight group being linked to and update gui option.
function M.mod_hl(hl_name, opts, keep)
  local is_ok, hl_def = pcall(vim.api.nvim_get_hl_by_name, hl_name, true)
  if is_ok then M.set_hl(hl_name, opts, hl_def, keep) end
end

--- Get highlight properties for a given highlight name
---@param name string The highlight group name
---@param fallback? table The fallback highlight properties
---@return table properties # the highlight group properties
function M.get_hlgroup(name, fallback)
  if vim.fn.hlexists(name) == 1 then
    local hl
    if vim.api.nvim_get_hl then -- check for new neovim 0.9 API
      hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      if not hl.fg then hl.fg = "NONE" end
      if not hl.bg then hl.bg = "NONE" end
    else
      hl = vim.api.nvim_get_hl_by_name(name, vim.o.termguicolors)
      if not hl.foreground then hl.foreground = "NONE" end
      if not hl.background then hl.background = "NONE" end
      hl.fg, hl.bg = hl.foreground, hl.background
      hl.ctermfg, hl.ctermbg = hl.fg, hl.bg
      hl.sp = hl.special
    end
    return hl
  end
  return fallback or {}
end

--
-- String helpers
--
function M.str_contains(haystack, needle)
  return string.find(haystack, needle, 1, true) ~= nil
end

function M.str_startswith(str, start) return string.sub(str, 1, #start) == start end

function M.str_endswith(str, ending)
  return ending == "" or string.sub(str, -#ending) == ending
end

function M.str_replace(original, old, new)
  return string.gsub(original, old, new)
end

function M.str_insert(str, pos, text)
  return string.sub(str, 1, pos - 1) .. text .. string.sub(str, pos)
end

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

--- Insert one or more values into a list like table and maintain that you do not insert non-unique values (THIS MODIFIES `lst`)
---@param lst any[]|nil The list like table that you want to insert into
---@param vals any|any[] Either a list like table of values to be inserted or a single value to be inserted
---@return any[] # The modified list like table
function M.list_insert_unique(lst, vals)
  if not lst then lst = {} end
  assert(vim.tbl_islist(lst), "Provided table is not a list like table")
  if not vim.tbl_islist(vals) then vals = { vals } end
  local added = {}
  vim.tbl_map(function(v) added[v] = true end, lst)
  for _, val in ipairs(vals) do
    if not added[val] then
      table.insert(lst, val)
      added[val] = true
    end
  end
  return lst
end

-- [[ Utility functions ]]

-- Table helpers
function M.tbl_length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

-- File Helpers
function M.shorten_path(path, cwd, target_width)
  local path_ok, plenary_path = pcall(require, "plenary.path")
  if not path_ok then return path end
  target_width = target_width or 35

  local short_fn
  if cwd then
    short_fn = vim.fn.fnamemodify(path, ":.")
  else
    short_fn = vim.fn.fnamemodify(path, ":~")
  end

  if #short_fn > target_width then
    short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
    if #short_fn > target_width then
      short_fn = plenary_path.new(short_fn):shorten(1, { -1 })

      if #short_fn > target_width then
        local parts = M.str_split(short_fn, "%.")
        local file_part = short_fn
        local ell = "..."
        local ext = ""

        if #parts > 1 then
          file_part = unpack(parts, 1, #parts - 1)
          ext = parts[#parts] or ""
        end

        local to_remove = target_width - #ext - #ell
        if #file_part > to_remove then
          file_part = string.sub(file_part, 1, to_remove)
        end
        local filename = file_part .. ell .. ext
        if #filename > 0 then short_fn = filename end
      end
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

-- Command helpers

function M.create_user_command(name, fn, opts)
  vim.api.nvim_create_user_command(name, function()
    if type(fn) == "function" then
      fn()
    else
      vim.notify(vim.inspect(fn))
    end
  end, opts)
end

-- Cursor & Selection helpers
function M.get_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return { row = cursor[1], col = cursor[2] }
end

function M.get_visual_selection_bounds()
  local vpos = vim.fn.getpos "v"
  local begin_pos = { row = vpos[2], col = vpos[3] - 1 }
  local end_pos = M.get_cursor()
  if
    (begin_pos.row < end_pos.row)
    or ((begin_pos.row == end_pos.row) and (begin_pos.col <= end_pos.col))
  then
    return { start = begin_pos, ["end"] = end_pos }
  else
    return { start = end_pos, ["end"] = begin_pos }
  end
end

function M.get_visual_selection()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos ".")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "v")
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
      "n",
      true
    )
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
    _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")
  end
  -- swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end
  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end
  local lines = vim.fn.getline(csrow, cerow)
  -- local n = cerow-csrow+1
  local n = M.tbl_length(lines)
  if n <= 0 then return "" end
  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, "\n")
end

-- Settings
function M.get_plugin_config(module)
  if not module or module == "" then return nil end
  local ok, mod = pcall(require, "user.plugins.config." .. module)
  if ok then
    return mod
  else
    return nil
  end
end

-- Merge modules
M = vim.tbl_extend("force", M, random)
M = vim.tbl_extend("force", M, require "user.utils.workspace")
M = vim.tbl_extend("force", M, require "user.utils.buffer")

-- Load autocmds
require "user.utils.autocmds"

return M
