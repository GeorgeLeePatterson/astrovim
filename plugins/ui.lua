return {
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
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
