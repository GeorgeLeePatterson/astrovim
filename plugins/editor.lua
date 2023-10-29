local user_config = require "user.config"
local ufo_config = require "user.plugins.config.ufo"
local telescope_config = require "user.plugins.config.telescope"
local favorite = user_config.get_config "mappings.favorite"

return {
  -- [[ Layout & Editor ]]

  -- Edgy
  {
    "folke/edgy.nvim",
    event = "VeryLazy", -- "VimEnter",
    keys = {
      {
        "<leader>e",
        function()
          require("edgy").toggle()
          local ok, symbols = pcall(require, "symbols-outline")
          if ok then pcall(symbols.close_outline) end
        end,
        desc = favorite "Edgy Toggle",
      },
    },
    -- -- This is recommended but actually makes it worse imo
    -- init = function() vim.opt.splitkeep = "screen" end,
    opts = require "user.plugins.config.edgy",
  },

  -- Rainbow-delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "User AstroFile",
  },

  -- Zen
  {
    "folke/zen-mode.nvim",
    dependencies = {
      {
        "folke/twilight.nvim",
        opts = {
          dimming = {
            alpha = 0.4,
          },
          context = 16,
        },
      },
    },
    cmd = "ZenMode",
    config = function(_, opts)
      opts.window = { width = 0.618 }
      local zen = require "zen-mode"
      zen.setup(opts)
      if require("user.config").defaults.zen then zen.toggle(opts) end
    end,
  },

  -- Mini.bufremove
  { "echasnovski/mini.bufremove" },

  -- [[ Telescope ]]
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jvgrootveld/telescope-zoxide",
      { "tiagovla/scope.nvim" },
      {
        "nvim-telescope/telescope-github.nvim",
        config = function() require("telescope").load_extension "gh" end,
      },
    },
    keys = {
      {
        "<leader>M",
        function() vim.cmd [[Telescope notify]] end,
        desc = "Messages",
      },
    },
    config = telescope_config,
  },

  -- [[ Symbols ]]
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>vs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
    },
    opts = { position = "right" },
    config = true,
  },

  -- [[ Search ]]

  -- Muren
  {
    "AckslD/muren.nvim",
    cmd = { "MurenOpen", "MurenFresh", "MurenUnique" },
    event = { "BufNewFile", "BufAdd" },
    keys = {
      {
        "<leader>sn",
        function() vim.cmd [[MurenOpen]] end,
        mode = { "n", "v", "s" },
        desc = "Open Muren search",
      },
    },
    config = function()
      require("muren").setup {
        anchor = "bottom_right",
      }
    end,
  },

  -- Spectre
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      {
        "<leader>so",
        function() vim.cmd [[Spectre]] end,
        mode = { "n", "v", "s" },
        desc = "Start spectre search",
      },
    },
    opts = function()
      local prefix = "<leader>s"
      return {
        open_cmd = "new",
        mapping = {
          send_to_qf = { map = prefix .. "q" },
          replace_cmd = { map = prefix .. "c" },
          show_option_menu = { map = prefix .. "o" },
          run_current_replace = { map = prefix .. "C" },
          run_replace = { map = prefix .. "R" },
          change_view_mode = { map = prefix .. "v" },
          resume_last_search = { map = prefix .. "l" },
        },
      }
    end,
  },

  -- Vim-illuminate
  {
    "RRethy/vim-illuminate",
    event = "User AstroFile",
    opts = {
      large_file_cutoff = (vim.g.max_file or {})["lines"] or 10000,
    },
    config = function(_, opts) require("illuminate").configure(opts) end,
  },

  -- [[ Folding ]]
  {
    "kevinhwang91/nvim-ufo",
    config = function(_, opts)
      opts.fold_virt_text_handler = ufo_config.handler
      require("ufo").setup(opts)
    end,
  },
}
