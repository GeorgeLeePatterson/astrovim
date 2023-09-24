return {
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
