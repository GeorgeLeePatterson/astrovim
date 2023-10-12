local M = {}
local ascii_art = require "user.ascii"

--
-- HELPERS
--
local astro_utils = require "astronvim.utils"
local user_utils = require "user.utils"
local is_available = astro_utils.is_available
local insert_unique = astro_utils.list_insert_unique
local shorten_path = user_utils.shorten_path
local random_gen = user_utils.random_gen
local fix_session_name = require("user.plugins.config.resession").session_name_to_path

-- Get sessions
function M.get_session_buttons()
  local dashboard = require "alpha.themes.dashboard"
  local session_buttons = {}
  if is_available "resession.nvim" then
    local sessions = require("resession").list() or {}
    local saved_session_count = #sessions
    local dir_options = { dir = "dirsession" }
    sessions = insert_unique(sessions, require("resession").list(dir_options))
    -- Set dir options for load
    local letters = { "q", "w", "a", "s", "d", "r", "i", "o" }
    if #sessions > 0 then
      local cwd = vim.fn.getcwd()
      local sess_buttons = {
        { type = "text", val = "Sessions", opts = { hl = "Title", position = "center", priority = 2 } },
        { type = "padding", val = 1 },
      }
      local cur_bufnr = vim.api.nvim_get_current_buf()
      -- local group = vim.api.nvim_create_augroup("alpha_start", { clear = true })

      for i, session in ipairs(sessions) do
        if i > #letters then break end
        local display = letters[i]
        local filename = session
        filename = fix_session_name(filename)
        if i > saved_session_count then
          filename = shorten_path(filename, cwd)
          dir_options["dir"] = "'dirsession'"
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
        local file_button_el = dashboard.button(display, filename, table.concat(command))
        file_button_el.opts.hl = {
          { "Character", 0, #ico },
          { "Normal", #ico - 2, #filename },
        }
        file_button_el.opts.hl_shortcut = "Keyword"
        table.insert(sess_buttons, file_button_el)
      end

      session_buttons = {
        type = "group",
        val = sess_buttons,
        opts = {},
      }
    end
  end
  return session_buttons
end

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

function M.colored(lines, hl)
  local out = {}
  for _, line in ipairs(lines) do
    table.insert(out, { hi = hl, line = line })
  end
  return out
end

function M.headers()
  local _, name, cur_header = ascii_art.random()
  local color_style = random_gen { "cool", "robust", "efficient" }

  -- Since the header gets turned into a list of lists, "center" no longer works
  -- This makes all lines the same length
  local longest = user_utils.longest_line(cur_header)
  for i = 1, #cur_header do
    local needed = longest - vim.fn.strdisplaywidth(cur_header[i])
    if needed > 0 then cur_header[i] = cur_header[i] .. string.rep(" ", needed) end
  end

  -- special case for pacman
  if user_utils.str_startswith(name, "pacman") then return M.colored(cur_header, "YellowCustomFg") end

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
function M.header_color()
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

-- Keep track of changes
local session_bts_idx = nil

function M.configure()
  local dashboard = require "alpha.themes.dashboard"
  local opts = require "alpha.themes.theta"
  local config = opts.config
  config.layout[2] = M.header_color()

  if session_bts_idx ~= nil then return config end

  local mru = config.layout[4]

  -- Add session buttons if any
  local session_buttons = M.get_session_buttons()

  -- Button group at bottom
  local buttons = {
    type = "group",
    val = {
      { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
      { type = "padding", val = 1 },
      dashboard.button("e", "  New file", "<cmd>ene<CR>"),
      dashboard.button("LDR f", "󰱼  Find file"),
      dashboard.button("LDR F", "󱎸  Find text"),
      dashboard.button("u", "󱓞  Update plugins", "<cmd>Lazy sync<CR>"),
      dashboard.button("x", "󰅗  Quit", "<cmd>qa<CR>"),
    },
    position = "center",
  }

  local mru_idx = 4
  if session_buttons.val ~= nil then
    config.layout[4] = session_buttons
    config.layout[5] = { type = "padding", val = 2 }
    mru_idx = mru_idx + 2
    session_bts_idx = 4
  end

  config.layout[mru_idx] = mru
  config.layout[mru_idx + 1] = { type = "padding", val = 2 }
  config.layout[mru_idx + 2] = buttons

  -- disable DirChanged autocmd for now, until flickering is figured out
  -- config.opts.setup = nil

  return config
end

return M
