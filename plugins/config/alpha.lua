local M = {}
local header_art = {
  {
    [[                                         __]],
    [[                                        |  \]],
    [[ _______    ______    ______  __     __  \$$ ______ ____]],
    [[|       \  /      \  /      \|  \   /  \|  \|      \    \]],
    [[| $$$$$$$\|  $$$$$$\|  $$$$$$\\$$\ /  $$| $$| $$$$$$\$$$$\]],
    [[| $$  | $$| $$    $$| $$  | $$ \$$\  $$ | $$| $$ | $$ | $$]],
    [[| $$  | $$| $$$$$$$$| $$__/ $$  \$$ $$  | $$| $$ | $$ | $$]],
    [[| $$  | $$ \$$     \ \$$    $$   \$$$   | $$| $$ | $$ | $$]],
    [[ \$$   \$$  \$$$$$$$  \$$$$$$     \$     \$$ \$$  \$$  \$$]],
  },
  {
    [[___________________________________________________________/\\\_____________________]],
    [[ __/\\/\\\\\\_______/\\\\\\\\______/\\\\\_____/\\\____/\\\_\///_____/\\\\\__/\\\\\___]],
    [[  _\/\\\////\\\____/\\\/////\\\___/\\\///\\\__\//\\\__/\\\___/\\\__/\\\///\\\\\///\\\_]],
    [[   _\/\\\__\//\\\__/\\\\\\\\\\\___/\\\__\//\\\__\//\\\/\\\___\/\\\_\/\\\_\//\\\__\/\\\_]],
    [[    _\/\\\___\/\\\_\//\\///////___\//\\\__/\\\____\//\\\\\____\/\\\_\/\\\__\/\\\__\/\\\_]],
    [[     _\/\\\___\/\\\__\//\\\\\\\\\\__\///\\\\\/______\//\\\_____\/\\\_\/\\\__\/\\\__\/\\\_]],
    [[      _\///____\///____\//////////_____\/////_________\///______\///__\///___\///___\///__]],
  },
  {
    [[                                                                 ]],
    [[                                              _/                 ]],
    [[   _/_/_/      _/_/      _/_/    _/      _/      _/_/_/  _/_/    ]],
    [[  _/    _/  _/_/_/_/  _/    _/  _/      _/  _/  _/    _/    _/   ]],
    [[ _/    _/  _/        _/    _/    _/  _/    _/  _/    _/    _/    ]],
    [[_/    _/    _/_/_/    _/_/        _/      _/  _/    _/    _/     ]],
    [[                                                                 ]],
    [[                                                                 ]],
  },
  {
    [[                                                   ]],
    [[                                __                 ]],
    [[   ___      __    ___   __  __ /\_\    ___ ___     ]],
    [[ /' _ `\  /'__`\ / __`\/\ \/\ \\/\ \ /' __` __`\   ]],
    [[ /\ \/\ \/\  __//\ \L\ \ \ \_/ |\ \ \/\ \/\ \/\ \  ]],
    [[ \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\ ]],
    [[  \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/ ]],
    [[                                                   ]],
    [[                                                   ]],
  },
  {
    [[ ................................................. ]],
    [[ .%%..%%..%%%%%%...%%%%...%%..%%..%%%%%%..%%...%%. ]],
    [[ .%%%.%%..%%......%%..%%..%%..%%....%%....%%%.%%%. ]],
    [[ .%%.%%%..%%%%....%%..%%..%%..%%....%%....%%.%.%%. ]],
    [[ .%%..%%..%%......%%..%%...%%%%.....%%....%%...%%. ]],
    [[ .%%..%%..%%%%%%...%%%%.....%%....%%%%%%..%%...%%. ]],
    [[ ................................................. ]],
  },

  {
    [[ ___   __       ______       ______       __   __      ________      ___ __ __     ]],
    [[/__/\ /__/\    /_____/\     /_____/\     /_/\ /_/\    /_______/\    /__//_//_/\    ]],
    [[\::\_\\  \ \   \::::_\/_    \:::_ \ \    \:\ \\ \ \   \__.::._\/    \::\| \| \ \   ]],
    [[ \:. `-\  \ \   \:\/___/\    \:\ \ \ \    \:\ \\ \ \     \::\ \      \:.      \ \  ]],
    [[  \:. _    \ \   \::___\/_    \:\ \ \ \    \:\_/.:\ \    _\::\ \__    \:.\-/\  \ \ ]],
    [[   \. \`-\  \ \   \:\____/\    \:\_\ \ \    \ ..::/ /   /__\::\__/\    \. \  \  \ \]],
    [[    \__\/ \__\/    \_____\/     \_____\/     \___/_(    \________\/     \__\/ \__\/]],
    [[                                                                                   ]],
  },
  {
    [[            ____]],
    [[           /\   \]],
    [[          /  \___\]],
    [[         _\  / __/_]],
    [[        /\ \/_/\   \]],
    [[       /  \___\ \___\]],
    [[      _\  /   / / __/_]],
    [[     /\ \/___/\/_/\   \]],
    [[    /  \___\    /  \___\]],
    [[   _\  / __/_  _\  / __/_]],
    [[  /\ \/_/\   \/\ \/_/\   \]],
    [[ /  \___\ \___\ \___\ \___\]],
    [[ \  /   / /   / /   / /itz/]],
    [[  \/___/\/___/\/___/\/___/]],
  },
  {
    [[            ____]],
    [[           /\   \]],
    [[          /  \___\]],
    [[         _\  / __/_]],
    [[        /\ \/_/\   \]],
    [[       /  \___\ \___\]],
    [[      _\  / __/ / __/_]],
    [[     /\ \/_/\ \/_/\   \]],
    [[    /  \___\ \___\ \___\]],
    [[   _\  / __/ / __/ / __/_]],
    [[  /\ \/_/\ \/_/\ \/_/\   \]],
    [[ /  \___\ \___\ \___\ \___\]],
    [[ \  /   / /   / /   / /itz/]],
    [[  \/___/\/___/\/___/\/___/]],
  },
  {
    [[              ___]],
    [[             /  /\]],
    [[            /  /  \]],
    [[           /  /    \]],
    [[          /  /  /\  \]],
    [[         /  /  /  \  \]],
    [[        /  /  /    \  \]],
    [[       /  /  /  /\  \  \]],
    [[      /  /  /  /\ \  \  \]],
    [[     /  /  /  /  \ \  \  \]],
    [[    /  /  /__/____\ \  \  \]],
    [[   /  /____________\ \  \  \]],
    [[  /___________________\  \  /]],
    [[  \_______________________\/]],
  },
  {
    [[           ________]],
    [[          /\       \]],
    [[         /  \       \]],
    [[        /    \       \]],
    [[       /      \_______\]],
    [[       \      /       /]],
    [[     ___\    /   ____/___]],
    [[    /\   \  /   /\       \]],
    [[   /  \   \/___/  \       \]],
    [[  /    \       \   \       \]],
    [[ /      \_______\   \_______\]],
    [[ \      /       /   /       /]],
    [[  \    /       /   /       /]],
    [[   \  /       /\  /       /]],
    [[    \/_______/  \/_______/ 'logico']],
  },
  {
    [[           ________]],
    [[          /\       \]],
    [[         /  \       \]],
    [[        /    \       \]],
    [[       /      \_______\]],
    [[       \      / ___   /]],
    [[     ___\    / / __\_/___]],
    [[    /\   \  /  \/\       \]],
    [[   /  \  /\/___/  \       \]],
    [[  /    \ \___/ \__ \       \]],
    [[ /      \_______\ \ \_______\]],
    [[ \      /       /_/ /       /]],
    [[  \    /       /   /       /]],
    [[   \  /       /\  /       /]],
    [[    \/_______/  \/_______/]],
  },
  {
    [[           __]],
    [[          /\ \]],
    [[         /  \ \]],
    [[        / /\ \ \]],
    [[Thomas / / /\ \ \]],
    [[Moe   / / /__\_\ \]],
    [[     / /_/_______ \]],
    [[    /  \ \______/\ \]],
    [[   / /\ \ \  / /\ \ \]],
    [[  / / /\ \ \/ / /\ \ \]],
    [[ / / /__\_\/ / /__\_\ \]],
    [[/ / /______\/ /________\]],
    [[\/_____________________/]],
  },
  {
    [[                  .-: -:`; .]],
    [[                 .~ .'i77x-,>` - .]],
    [[                 :.`(()l` `''<(<. :.]],
    [[               .'-,`<>> J$$$hc,`-11>:]],
    [[               ; : (<7'+$$$$$$$$,`<7:.]],
    [[             .`: -<<77: $$$$"cc"$  :< .]],
    [[             .~ - :<.;. $$F,$$$$i6 <>/:]],
    [[            .'. >`<>)>: $$z$""?$$$'<>/-.]],
    [[            ,- ,-.<<,i>'$$F,$$h"$P>`) .]],
    [[           ./.: >.-7('`'$$ """"  U `` ~:]],
    [[           ;- <->1-:-' J$$L==",d$$L`F \.]],
    [[         .:--:>>')><-  $$$$$$$$$$$$d' ( .]],
    [[         :.-./->-.'-  d??$$$$$$$$$'d  /) .]],
    [[       .'> -:<-`:  - <$$?$$$$$$$$$   .`l>:]],
    [[       -.:</.`': ' u>     z$$$$$$' -  `7(-`.]],
    [[     .'.//l)/ : '  ?h>  ,d$$$$$P'  . : `(<':]],
    [[   . <((1)>-`<  .   "$$$$$$$$F'cX   : ''`>`-~.]],
    [[  .:<77<:` ,,  -  `  `"???"',d$$C  . :  \>)< ~.]],
    [[  .(-1<- ,$$$$hc,  '- ~,cd$$$$$$$    -.` /<\7-:]],
    [[.:.:-` ,$$$$$$$$$$hcccd$$$$$$$$$$c,,..   `,7(+ .]],
  },
}

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

function M.headers()
  local cur_header = random_gen(header_art)
  local color_style = random_gen { "cool", "cool2", "cool3", "robust", "efficient" }

  -- Since the header gets turned into a list of lists, "center" no longer works
  -- This makes all lines the same length
  local longest = user_utils.longest_line(cur_header)
  for i = 1, #cur_header do
    local needed = longest - vim.fn.strdisplaywidth(cur_header[i])
    if needed > 0 then cur_header[i] = cur_header[i] .. string.rep(" ", needed) end
  end

  -- color_style = "efficient"

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
