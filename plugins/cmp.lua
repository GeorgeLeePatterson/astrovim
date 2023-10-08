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
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-emoji",
      "neovim/nvim-lspconfig",
      "simrat39/rust-tools.nvim",
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
  -- {
  --   "codota/tabnine-nvim",
  --   config = function() require "" end,
  -- },
}
