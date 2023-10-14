local icons = require("user.config").icons

return {
  {
    "rebelot/heirline.nvim",
    dependencies = {
      "akinsho/horizon.nvim",
      "sainnhe/gruvbox-material",
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function(_, opts) return require "user.plugins.config.heirline"(opts) end,
    config = require "plugins.configs.heirline",
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = require "user.plugins.config.bufferline",
    event = "VeryLazy",
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPre",
    keys = {
      {
        "g<Tab>",
        function() require("dropbar.api").pick() end,
        mode = { "n" },
        desc = "Dropbar Nav",
      },
    },
    config = function()
      require("dropbar").setup {
        manu = {
          icons = {
            kinds = icons.kinds,
          },
        },
      }
    end,
  },
  -- Only here to provide themes to astronvim heirline
  "nvim-lualine/lualine.nvim",
}
