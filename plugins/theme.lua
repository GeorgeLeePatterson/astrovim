local user_utils = require "user.utils"
local user_config = require "user.config"

return {
  { "nyoom-engineering/oxocarbon.nvim", priority = 1000 },
  { "tiagovla/tokyodark.nvim", priority = 1000 },
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "marko-cerovac/material.nvim" },
  { "dasupradyumna/midnight.nvim", priority = 1000 },
  { "akinsho/horizon.nvim", version = "*", priority = 1000 },
  { "zootedb0t/citruszest.nvim", priority = 1000 },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "darker",
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "storm",
      light_style = "day",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      integrations = {
        notify = true,
        aerial = true,
        alpha = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
        lsp_saga = true,
        neotree = true,
        noice = true,
        navic = true,
        lsp_trouble = true,
      },
    },
    priority = 1000,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup {
        -- dim_inactive = true,
        styles = {
          comments = "italic",
          functions = "callout",
        },
      }
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 999, -- Load after colorschemes
    enabled = user_config.defaults.background_toggle,
    config = function(_, opts)
      opts.update_interval = 1000
      opts.set_dark_mode = function() user_utils.set_background_and_theme("dark", user_config.defaults.theme.dark) end
      opts.set_light_mode = function() user_utils.set_background_and_theme("light", user_config.defaults.theme.light) end
      require("auto-dark-mode").setup(opts)
    end,
  },
}
