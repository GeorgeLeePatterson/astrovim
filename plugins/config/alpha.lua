-- Keep track of changes
local session_bts_idx = nil

-- Main configuration of alpha dashboard
return function(opts)
  local alpha_utils = require "user.utils.dashboard"
  local mru = alpha_utils.mru

  if not alpha_utils then return end

  local dashboard = require "alpha.themes.dashboard"
  local user_config = require "user.config"
  opts = vim.tbl_deep_extend("force", require "alpha.themes.theta", opts or {})

  local config = opts.config
  config.layout[2] = alpha_utils.header_colored()

  if session_bts_idx ~= nil then return config end

  local section_mru = {
    type = "group",
    val = {
      {
        type = "text",
        val = "Recent files",
        opts = {
          hl = "SpecialComment",
          shrink_margin = false,
          position = "center",
        },
      },
      { type = "padding", val = 1 },
      {
        type = "group",
        val = function() return { mru(0, vim.fn.getcwd()) } end,
        opts = { shrink_margin = false },
      },
    },
  }

  -- Add session buttons if any
  local session_buttons = {}
  if user_config["use_resession"] then
    session_buttons = alpha_utils.get_session_buttons()
  else
    session_buttons = alpha_utils.get_z_dirs_buttons()
  end

  -- Button group at bottom
  local buttons = {
    type = "group",
    val = {
      {
        type = "text",
        val = "Quick links",
        opts = { hl = "SpecialComment", position = "center" },
      },
      { type = "padding", val = 1 },
      dashboard.button("LDR f", "󰱼  Find file"),
      dashboard.button("LDR F", "󱎸  Find text"),
      dashboard.button("u", "󱓞  Update plugins", "<cmd>Lazy sync<CR>"),
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

  config.layout[mru_idx] = section_mru
  config.layout[mru_idx + 1] = { type = "padding", val = 2 }
  config.layout[mru_idx + 2] = buttons

  config.opts.noautocmd = true

  return config
end
