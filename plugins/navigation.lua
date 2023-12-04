---@diagnostic disable: missing-parameter
local alpha_config = require "user.plugins.config.alpha"

local user_config = require "user.config"
local favorite = user_config.get_config "mappings.favorite"

return {
  -- [[ Dashboard ]]
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function() require("alpha").setup(alpha_config {}) end,
  },

  -- [[ Search & Grep ]]
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
  },
  {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    event = { "VeryLazy" },
    keys = {
      {
        "<Leader>jf",
        function() vim.cmd "FzfLua files" end,
        mode = { "n", "v" },
        desc = "[f]iles",
      },
      {
        "<Leader>js",
        function() vim.cmd "FzfLua live_grep" end,
        mode = { "n", "v" },
        desc = "[s]earch",
      },
      {
        "<Leader>jS",
        function() vim.cmd "FzfLua live_grep_native" end,
        mode = { "n", "v" },
        desc = "[S]earch (performant)",
      },
      {
        "<Leader>jm",
        function() vim.cmd "FzfLua marks" end,
        mode = { "n", "v" },
        desc = "[m]arks",
      },
      {
        "<Leader>j<CR>",
        function() vim.cmd "FzfLua resume" end,
        mode = { "n", "v" },
        desc = "[Enter] Resume",
      },
      {
        "<Leader>jb",
        function() vim.cmd "FzfLua buffers" end,
        mode = { "n", "v" },
        desc = "[b]uffers",
      },
      {
        "<Leader>jv",
        function() vim.cmd "FzfLua grep_visual" end,
        mode = { "n", "v" },
        desc = favorite "grep [v]isual",
      },
      {
        "<Leader>jj",
        function() vim.cmd [[FzfLua jumps]] end,
        mode = { "n", "v" },
        desc = "[j]ump list",
      },
    },
    config = function(...)
      local ok, conf = pcall(require, "user.plugins.config.fzf-lua")
      if ok then conf(...) end
    end,
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
      open_files_do_not_replace_types = {
        "terminal",
        "Trouble",
        "qf",
        "notify",
        "Outline",
        "edgy",
        "help",
      },
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
          ["J"] = "use_flash",
        },
      },
      source_selector = {
        content_layout = "start",
        tabs_layout = "active",
      },
    },
  },
  {
    "glepnir/flybuf.nvim",
    cmd = "FlyBuf",
    config = function() require("flybuf").setup {} end,
  },
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
