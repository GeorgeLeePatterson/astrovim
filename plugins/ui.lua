return {
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
      -- {
      --   "<C-f>",
      --   function()
      --     if not require("noice.lsp").scroll(4) then return "<C-f>" end
      --   end,
      --   mode = { "n", "i", "s" },
      --   desc = "Lsp scroll down",
      --   { silent = true, expr = true, noremap = true },
      -- },
      -- {
      --   "<C-b>",
      --   function()
      --     if not require("noice.lsp").scroll(-4) then return "<C-b>" end
      --   end,
      --   mode = { "n", "i", "s" },
      --   desc = "Lsp scroll up",
      --   { silent = true, expr = true, noremap = true },
      -- },
      { "<leader>vC", function() require("notify").dismiss {} end, mode = { "n" }, desc = "Clear all notifications" },
    },
    event = "VeryLazy",
    config = require("user.plugins.config.noice").config,
  },
  {
    "stevearc/dressing.nvim",
    lazy = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      input = { enabled = false },
    },
  },
}
