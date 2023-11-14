local path_ok, _ = pcall(require, "plenary.path")
if not path_ok then return end

local dashboard = require "alpha.themes.dashboard"

local ascii_art = require "user.ascii"
local workspace = require "user.utils.workspace"

local astro_utils = require "astronvim.utils"
local user_utils = require "user.utils"

local is_available = astro_utils.is_available
local shorten_path = user_utils.shorten_path
local random_gen = user_utils.random_gen
local fix_session_name =
  require("user.plugins.config.resession").session_name_to_path

local if_nil = vim.F.if_nil

local M = {}

local function get_extension(fn)
  local match = fn:match "^.+(%..+)$"
  local ext = ""
  if match ~= nil then ext = match:sub(2) end
  return ext
end

local nvim_web_devicons = {
  enabled = true,
  highlight = true,
}

local function icon(fn)
  local nwd = require "nvim-web-devicons"
  local ext = get_extension(fn)
  return nwd.get_icon(fn, ext, { default = true })
end

-- [[ Buttons ]]

local function file_button(fn, sc, short_fn, autocd)
  short_fn = short_fn or fn
  local ico_txt
  local fb_hl = {}

  if nvim_web_devicons.enabled then
    local ico, hl = icon(fn)
    local hl_option_type = type(nvim_web_devicons.highlight)
    if hl_option_type == "boolean" then
      if hl and nvim_web_devicons.highlight then
        table.insert(fb_hl, { hl, 0, #ico })
      end
    end
    if hl_option_type == "string" then
      table.insert(fb_hl, { nvim_web_devicons.highlight, 0, #ico })
    end
    ico_txt = ico .. "  "
  else
    ico_txt = ""
  end
  local cd_cmd = (autocd and " | cd %:p:h" or "")
  local file_button_el = dashboard.button(
    sc,
    ico_txt .. short_fn,
    "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>"
  )
  local fn_start = short_fn:match ".*[/\\]"
  if fn_start ~= nil then
    table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt })
  end
  file_button_el.opts.hl = fb_hl
  return file_button_el
end

-- [[ MRU ]]

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
  ignore = function(path, ext)
    return (string.find(path, "COMMIT_EDITMSG"))
      or (vim.tbl_contains(default_mru_ignore, ext))
  end,
  autocd = false,
}

local function get_old_files(cwd, items_number, opts, skip)
  skip = skip or {}
  local oldfiles = {}
  for _, v in pairs(vim.v.oldfiles) do
    if #oldfiles == items_number then break end
    if not vim.list_contains(skip, v) then
      local cwd_cond
      if not cwd then
        cwd_cond = true
      else
        cwd_cond = vim.startswith(v, cwd)
      end
      local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
      if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
        oldfiles[#oldfiles + 1] = v
      end
    end
  end
  return oldfiles
end

--- @param start number
--- @param cwd string? optional
--- @param items_number number? optional number of items to generate, default = 10
M.mru = function(start, cwd, items_number, opts)
  opts = opts or mru_opts
  items_number = if_nil(items_number, 10)

  local get_mru = function()
    local filtered_oldfiles = get_old_files(cwd, items_number, opts, {})

    if #filtered_oldfiles < 10 then
      local additional = 10 - #filtered_oldfiles
      local more_oldfiles =
        get_old_files(nil, additional, opts, filtered_oldfiles)
      for _, v in ipairs(more_oldfiles) do
        filtered_oldfiles[#filtered_oldfiles + 1] = v
      end
    end
    local oldfiles = filtered_oldfiles

    local target_width = 35

    local tbl = {}
    for i, fn in ipairs(oldfiles) do
      local short_fn = user_utils.shorten_path(fn, cwd, target_width) or fn
      local shortcut = tostring(i + start - 1)
      local file_button_el = file_button(fn, shortcut, short_fn, opts.autocd)
      tbl[i] = file_button_el
    end
    return tbl
  end

  return {
    type = "group",
    val = get_mru(),
    opts = {},
  }
end

-- [[ Directories ]]

-- Get directories
function M.get_z_dirs_buttons()
  local buttons = {}
  local z_scores = workspace.z_get_scores() or {}
  if #z_scores > 0 then
    local cwd = vim.fn.getcwd()
    -- Set dir options for load
    local letters = { "q", "w", "a", "s", "d" } -- , "r", "i", "o" }
    local colors = {
      "DeeppinkCustomFg",
      "MediumorchidCustomFg",
      "HotpinkCustomFg",
    }
    local _buttons = {
      {
        type = "text",
        val = "~ Z DIRS ~",
        opts = { hl = "Title", position = "center", priority = 2 },
      },
      { type = "padding", val = 1 },
    }
    local alpha_bufnr = vim.api.nvim_get_current_buf()
    for index, entry in ipairs(z_scores) do
      if index > #letters then break end
      local display = letters[index]
      -- local score = entry[1]
      local dir = entry[2]
      if dir then
        local ico = "  "
        if index == 1 then ico = "  " end
        local filename = shorten_path(dir, cwd) or ""

        filename = ico .. " " .. filename
        local command = {
          "<cmd>lua require('user.utils.workspace').chdir(",
          "'",
          dir,
          "',",
          alpha_bufnr,
          ")<CR>",
        }
        local hl = colors[index] or "Normal"
        local file_button_el =
          dashboard.button(display, filename, table.concat(command))
        file_button_el.opts.hl = {
          { "Character", 0, #ico },
          { hl, #ico - 2, #filename },
        }
        file_button_el.opts.hl_shortcut = "Keyword"
        table.insert(_buttons, file_button_el)
      end
    end
    buttons = {
      type = "group",
      val = _buttons,
      opts = {},
    }
  end
  return buttons
end

-- Get sessions
function M.get_session_buttons()
  local session_buttons = {}
  if is_available "resession.nvim" then
    local sessions = require("resession").list() or {}
    local all_sessions = astro_utils.list_insert_unique(
      sessions,
      require("resession").list() or {}
    )
    local dir_options = { dir = "dirsession" }
    -- Set dir options for load
    local letters = { "q", "w", "a", "s", "d", "r", "i", "o" }
    if #sessions > 0 then
      local cwd = vim.fn.getcwd()
      local sess_buttons = {
        {
          type = "text",
          val = "Sessions",
          opts = { hl = "Title", position = "center", priority = 2 },
        },
        { type = "padding", val = 1 },
      }
      local cur_bufnr = vim.api.nvim_get_current_buf()
      for i, session in ipairs(all_sessions) do
        if i > #letters then break end
        local display = letters[i]
        local filename = fix_session_name(session) or ""
        if i > #sessions and filename ~= "" then
          filename = shorten_path(filename, cwd) or ""
        else
          dir_options["dir"] = "nil"
        end

        local ico = "  "
        if filename == "Last Session" then ico = "  " end
        filename = ico .. filename
        local command = {
          "<cmd>lua require('user.plugins.config.resession').open_from_dashboard(",
          "'",
          session,
          "',",
          dir_options["dir"],
          ",",
          cur_bufnr,
          ",",
          "'alpha_temp'",
          ")<CR>",
        }
        local file_button_el =
          dashboard.button(display, filename, table.concat(command))
        file_button_el.opts.hl = {
          { "Character", 0, #ico },
          { "Normal", #ico - 2, #filename },
        }
        file_button_el.opts.hl_shortcut = "Keyword"
        table.insert(sess_buttons, file_button_el)
      end
      session_buttons = { type = "group", val = sess_buttons, opts = {} }
    end
  end
  return session_buttons
end

-- [[Different gradient style helpers]]

function M.lineToStartGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    table.insert(out, { hi = "StartLogo" .. i, line = line })
  end
  return out
end

function M.lineToStartPopGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    local hi = "StartLogo" .. i
    if i <= 6 then
      hi = "StartLogo" .. i + 6
    elseif i > 6 and i <= 12 then
      hi = "StartLogoPop" .. i - 6
    end
    table.insert(out, { hi = hi, line = line })
  end
  return out
end

function M.lineToStartShiftGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    local n = i
    if i > 6 and i <= 12 then
      n = i + 6
    elseif i > 12 then
      n = i - 6
    end
    table.insert(out, { hi = "StartLogo" .. n, line = line })
  end
  return out
end

-- Simple helper function to wrap dashboard header lines with hl
function M.colored(lines, hl)
  local out = {}
  for _, line in ipairs(lines) do
    table.insert(out, { hi = hl, line = line })
  end
  return out
end

-- Generate random header, random gradient type, then return
function M.headers()
  local _, name, cur_header = ascii_art.random()
  local color_style = random_gen { "cool", "robust", "efficient" }

  -- Since the header gets turned into a list of lists, "center" no longer works
  -- This makes all lines the same length
  local longest = user_utils.longest_line(cur_header)
  for i = 1, #cur_header do
    local needed = longest - vim.fn.strdisplaywidth(cur_header[i])
    if needed > 0 then
      cur_header[i] = cur_header[i] .. string.rep(" ", needed)
    end
  end

  -- special case for pacman
  if user_utils.str_startswith(name, "pacman") then
    return M.colored(cur_header, "YellowCustomFg")
  end

  if string.find(color_style, "cool", 1, true) ~= nil then
    return M.lineToStartPopGradient(cur_header)
  elseif string.find(color_style, "robust", 1, true) ~= nil then
    return M.lineToStartShiftGradient(cur_header)
  else
    return M.lineToStartGradient(cur_header)
  end
end

-- Map over the headers, setting a different color for each line.
-- This is done by setting the Highligh to StartLogoN, where N is the row index.
-- Define StartLogo1..StartLogoN to get a nice gradient.
function M.header_colored()
  local lines = {}
  for _, lineConfig in pairs(M.headers()) do
    local hi = lineConfig.hi
    local line_chars = lineConfig.line
    local line = {
      type = "text",
      val = line_chars,
      opts = {
        hl = hi,
        shrink_margin = false,
        position = "center",
      },
    }
    table.insert(lines, line)
  end

  local output = {
    type = "group",
    val = lines,
    opts = { position = "center" },
  }

  return output
end

return M
