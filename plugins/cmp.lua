local cmp_utils = require "user.plugins.config.cmp"

return {
  {
    "hrsh7th/nvim-cmp",
    keys = { ":", "?", "/" },
    event = { "InsertEnter", "CmdlineEnter" },
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "neovim/nvim-lspconfig",
      "simrat39/rust-tools.nvim",
      {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function() require("copilot_cmp").setup() end,
      },
    },
    opts = cmp_utils.opts,
    config = cmp_utils.config,
  },
  { "onsails/lspkind.nvim" },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    enabled = require("user.config").ai.copilot,
    config = function()
      require("copilot").setup {
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        suggestion = {
          enabled = false, -- true,
          auto_trigger = true,
          debounce = 50,
          keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<Tab-CR>",
          },
        },
      }
    end,
  },
  -- Pretty disapponted with tabnine, copilot is much better
  -- TODO: remove this
  {
    "tzachar/cmp-tabnine",
    event = "VeryLazy",
    build = "./install.sh",
    dependencies = "hrsh7th/nvim-cmp",
    config = function()
      local tabnine = require "cmp_tabnine.config"
      tabnine:setup {
        max_lines = 1000,
        max_num_results = 2,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = "..",
        show_prediction_strength = true,
      }
    end,
  },
}
