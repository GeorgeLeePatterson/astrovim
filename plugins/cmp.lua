local cmp_utils = require "user.plugins.config.cmp"

return {
  {
    "hrsh7th/nvim-cmp",
    keys = { ":", "?", "/" },
    event = { "InsertEnter", "CmdlineEnter" },
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "neovim/nvim-lspconfig",
      "simrat39/rust-tools.nvim",
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
      -- "zbirenbaum/copilot-cmp",
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
          enabled = true,
          auto_trigger = true,
          debounce = 50,
          keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      }
    end,
  },
  {
    "tzachar/cmp-tabnine",
    event = "VeryLazy",
    build = "./install.sh",
    dependences = "hrsh7th/nvim-cmp",
    config = function()
      local tabnine = require "cmp_tabnine.config"
      tabnine:setup {
        max_lines = 1000,
        max_num_results = 10,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = "..",
        show_prediction_strength = true,
      }
    end,
  },
  -- {
  --   "codota/tabnine-nvim",
  --   cmd = "TabnineHub",
  --   build = "./dl_binaries.sh",
  --   event = "VeryLazy",
  --   enabled = require("user.config").ai.tabnine,
  --   config = function()
  --     require("tabnine").setup {
  --       disable_auto_comment = false,
  --       accept_keymap = "<Tab>",
  --       dismiss_keymap = "<C-]>",
  --       debounce_ms = 800,
  --       suggestion_color = { gui = "#FF0000", cterm = 244 },
  --       exclude_filetypes = { "TelescopePrompt", "neo-tree" },
  --       -- log_file_path = nil, -- absolute path to Tabnine log file
  --     }
  --   end,
  -- },
}
