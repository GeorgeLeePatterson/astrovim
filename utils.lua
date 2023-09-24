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

  local default_theme = user_config.defaults.theme[bg]
  theme = theme or default_theme

  -- Change color scheme
  vim.cmd.colorscheme(theme)

  -- Change background mode
  if cur_mode ~= bg then vim.o.background = bg end
  vim.notify("Changed mode from " .. cur_mode .. " to " .. bg .. "\nChanged theme to " .. theme, vim.log.levels.INFO)

  -- Reload bufferline
  if a_utils.is_available "bufferline" then
    vim.schedule(function() require("bufferline").setup(user_config.bufferline) end)
  end
end
return M
