return {
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    opts = {
      previewer_cmd = "glow",
      after_open = function(bufnr) vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", ":close<CR>", {}) end,
    },
  },
}
