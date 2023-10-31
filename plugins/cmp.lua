local get_config = require("user.utils").get_plugin_config

return {
  -- [[ Nvim-cmp ]]
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
      {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function() require("copilot_cmp").setup() end,
      },
    },
    config = get_config "cmp",
  },

  -- LspKind
  { "onsails/lspkind.nvim" },

  -- [[ AI ]]

  -- Copilot
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

  -- Tabnine
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
