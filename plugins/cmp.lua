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
}
