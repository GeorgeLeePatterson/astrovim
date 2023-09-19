return {
  {
    "nvimdev/lspsaga.nvim",
    config = function() require("lspsaga").setup {} end,
    after = "nvim-lspconfig",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
