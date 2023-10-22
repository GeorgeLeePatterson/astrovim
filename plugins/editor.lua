local ufo_config = require "user.plugins.config.ufo"
local telescope_config = require "user.plugins.config.telescope"

return {
  -- [[ Layout & Editor ]]
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
        desc = "Edgy Toggle",
      },
    },
    opts = require "user.plugins.config.edgy",
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "User AstroFile",
  },

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
    },
    keys = {
      { "<leader>M", function() vim.cmd [[Telescope notify]] end, desc = "Messages" },
    },
    opts = telescope_config.opts,
    config = telescope_config.config,
  },

  -- [[ Symbols ]]
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>vs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = { position = "right" },
    config = true,
  },

  -- [[ Search ]]
  {
    "ray-x/sad.nvim",
    cmd = "Sad",
    dependencies = {
      { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
    },
    keys = {
      {
        "<leader>ss",
        function() vim.cmd(":Sad " .. vim.fn.input "Enter search pattern: ") end,
        mode = { "n", "v", "s" },
        desc = "Sad s&r (cursor)",
      },
    },
    config = function() require("sad").setup {} end,
  },
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

  -- [[ Folding ]]
  {
    "kevinhwang91/nvim-ufo",
    config = function(_, opts)
      opts.fold_virt_text_handler = ufo_config.handler
      require("ufo").setup(opts)
    end,
  },
}
