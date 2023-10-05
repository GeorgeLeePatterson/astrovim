local theme_config = require "user.plugins.config.theme"

local themes = {}
table.insert(themes, theme_config.configure_theme "nyoom-engineering/oxocarbon.nvim")
table.insert(themes, theme_config.configure_theme "tiagovla/tokyodark.nvim")
table.insert(themes, theme_config.configure_theme "ellisonleao/gruvbox.nvim")
table.insert(themes, theme_config.configure_theme "marko-cerovac/material.nvim")
table.insert(themes, theme_config.configure_theme "dasupradyumna/midnight.nvim")
table.insert(themes, theme_config.configure_theme("akinsho/horizon.nvim", { version = "*" }))
table.insert(themes, theme_config.configure_theme "zootedb0t/citruszest.nvim")
table.insert(themes, theme_config.configure_theme "loctvl842/monokai-pro.nvim")
table.insert(
  themes,
  theme_config.configure_theme("navarasu/onedark.nvim", {
    priority = 1000,
    opts = {
      style = "darker",
    },
  })
)
table.insert(
  themes,
  theme_config.configure_theme("folke/tokyonight.nvim", {
    opts = {
      style = "storm",
      light_style = "day",
    },
  })
)
table.insert(themes, {
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
})
table.insert(
  themes,
  theme_config.configure_theme("projekt0n/github-nvim-theme", {
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
  })
)
-- table.insert(themes, {
--   "f-person/auto-dark-mode.nvim",
--   lazy = false,
--   priority = 999, -- Load after colorschemes
--   enabled = user_config.defaults.background_toggle,
--   config = function(_, opts)
--     opts.update_interval = 1000
--     opts.set_dark_mode = function() user_utils.set_background_and_theme("dark", user_config.defaults.theme.dark) end
--     opts.set_light_mode = function() user_utils.set_background_and_theme("light", user_config.defaults.theme.light) end
--     require("auto-dark-mode").setup(opts)
--   end,
-- })

return themes
