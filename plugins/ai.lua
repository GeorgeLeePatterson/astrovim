return {
  -- [[ AI ]]

  -- GPT - defaults below
  {
    "robitx/gp.nvim",
    event = "VeryLazy",
    enabled = require("user.config").ai.chatgpt,
    config = function()
      require("gp").setup {
        openai_api_key = os.getenv "OPENAI_API_KEY",
      }
    end,
  },

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
          enabled = true,
          auto_trigger = true,
          accept = false,
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

      -- hide copilot suggestions when cmp menu is open
      -- to prevent odd behavior/garbled up suggestions
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if cmp_status_ok then
        cmp.event:on(
          "menu_opened",
          function() vim.b.copilot_suggestion_hidden = true end
        )

        cmp.event:on(
          "menu_closed",
          function() vim.b.copilot_suggestion_hidden = false end
        )
      end
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
