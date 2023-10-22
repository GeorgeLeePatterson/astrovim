---@diagnostic disable: missing-parameter
local alpha_config = require "user.plugins.config.alpha"

return {
  -- [[ Dashboard ]]
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function() require("alpha").setup(alpha_config.configure()) end,
  },

  -- [[ Search & Grep ]]
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

  -- [[ Neo-tree ]]
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
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "notify", "Outline", "edgy" },
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
        use_libuv_file_watcher = true,
        -- Not sure but I think w/ edgy this is very important
        hijack_netrw_behavior = "open_default",
      },
      default_component_configs = {
        name = {
          highlight_opened_files = true,
        },
      },
      -- Add some additional mappings for moving around
      commands = {
        use_flash = function()
          local ok, flash = pcall(require, "flash")
          if ok then flash.jump() end
        end,
      },
      window = {
        width = 30,
        mappings = {
          ["gs"] = "use_flash",
        },
      },
      source_selector = {
        content_layout = "start",
        tabs_layout = "active",
      },
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
