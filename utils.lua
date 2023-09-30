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

function M.str_pad_len(str, total_len)
  if #str >= total_len then return str end
  return str .. string.rep(" ", total_len - #str)
end

function M.longest_line(tbl)
  local longest = 0
  for _, v in pairs(tbl) do
    local width = vim.fn.strdisplaywidth(v)
    if width > longest then longest = width end
  end
  return longest
end

-- List helper

function M.arr_has(arr, str)
  if not arr then return true end
  if not str then return false end
  for _, value in ipairs(arr) do
    if value == str then return true end
  end

  return false
end
--
-- Resession helpers
--

function M.session_name_to_path(name) return string.gsub(name, "_", "/") end

function M.open_from_dashboard(session, dir, bufnr, group)
  local found_group = nil
  -- Get alpha autocommands, delete if any
  local ok, autocommands = pcall(vim.api.nvim_get_autocmds, { group = group })
  if ok then
    for _, cmd in ipairs(autocommands) do
      if not pcall(function() vim.api.nvim_del_augroup_by_id(cmd.group) end) then found_group = cmd.group end
    end
  end
  -- Load resession
  if not pcall(function() require("resession").load(session, { dir = dir }) end) then
    vim.notify("Could not load session", vim.log.levels.ERROR)
  end
  -- Close alpha, ignore errors
  pcall(function() require("alpha").close { buf = bufnr, group = found_group } end)

  -- Try to close tab if possible
  -- TODO
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

-- Random
function M.random_gen(list)
  math.randomseed(os.time())
  return list[math.random(1, #list)]
end

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

return M
