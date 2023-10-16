---@diagnostic disable: missing-parameter
local alpha_config = require "user.plugins.config.alpha"

return {
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function() require("alpha").setup(alpha_config.configure()) end,
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    lazy = false,
  },
  {
    "nanotee/zoxide.vim",
    event = "VeryLazy",
    dependencies = {
      "junegunn/fzf.vim",
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        event = "VeryLazy",
        opts = {
          hint = "floating-big-letter",
          autoselect_one = true,
          include_current = true,
          filter_rules = {
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify", "Trouble" },

              -- if the buffer type is one of following, the window will be ignored
              -- buftype = { "terminal" },
            },
          },
        },
      },
    },
    opts = {
      open_files_do_not_replace_types = { "terminal", "trouble", "qf", "notify" },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          always_show = { ".github", ".gitignore" },
          hide_gitignored = false,
          never_show = { ".DS_Store" },
        },
        hijack_netrw_behavior = "open_default",
      },
      default_component_configs = {
        name = {
          highlight_opened_files = true,
        },
      },
      window = { width = 30 },
    },
  },
  { "glepnir/flybuf.nvim", cmd = "FlyBuf", config = function() require("flybuf").setup {} end },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    config = function() require("smoothcursor").setup() end,
  },
}
