local theme_config = require "user.plugins.config.theme"

local _themes = {
  {
    "EdenEast/nightfox.nvim",
    {
      opts = {
        options = {
          dim_inactive = true,
          styles = theme_config.common_styles,
        },
        groups = {},
      },
    },
  },
  { "uloco/bluloco.nvim", { dependencies = { "rktjmp/lush.nvim" } } },
  {
    "ramojus/mellifluous.nvim",
    {
      opts = {
        dim_inactive = true,
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
          types = { italic = true, bold = true },
        },
      },
    },
  },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "tiagovla/tokyodark.nvim" },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
  },

  {
    "ellisonleao/gruvbox.nvim",
    {
      opts = {
        italic = { comments = true },
        overrides = { LspInlayHint = { italic = false } },
      },
    },
  },
  { "marko-cerovac/material.nvim" },
  { "dasupradyumna/midnight.nvim" },
  { "akinsho/horizon.nvim", { version = "*" } },
  { "zootedb0t/citruszest.nvim" },
  { "loctvl842/monokai-pro.nvim" },
  {
    "navarasu/onedark.nvim",
    {
      lazy = false,
      priority = 1000,
      config = function()
        require("onedark").setup {
          style = "darker",
          toggle_style_key = "<leader>mt",
          code_style = theme_config.common_styles,
        }
      end,
    },
  },
  {
    "folke/tokyonight.nvim",
    {
      opts = {
        style = "storm",
        light_style = "day",
      },
    },
  },
  {
    "projekt0n/github-nvim-theme",
    {
      lazy = false,
      priority = 1000,
      config = function()
        require("github-theme").setup {
          dim_inactive = true,
          styles = theme_config.common_styles,
        }
      end,
    },
  },
}

-- Configure themes
local themes = vim.tbl_map(function(o)
  if not o then return {} end
  return theme_config.configure_theme(o[1], o[2] or {})
end, _themes)

-- Lush is used to calculate hexes and other helpful things
table.insert(themes, {
  {
    "rktjmp/lush.nvim",
    lazy = false,
    priority = 999,
    config = theme_config.configure_lush,
  },
})

-- TODO Fix error caused when mapping
table.insert(themes, {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = {
    integrations = {
      alpha = true,
      aerial = true,
      fidget = true,
      flash = true,
      headlines = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
      lsp_saga = true,
      lsp_trouble = true,
      neotree = true,
      noice = true,
      notify = true,
      symbols_outline = true,
    },
  },
  priority = 1000,
})

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
