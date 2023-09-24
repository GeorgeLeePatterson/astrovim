return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.motion/nvim-surround" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },
  { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  {
    import = "astrocommunity.editing-support/rainbow-delimiters-nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function() require("rainbow-delimiters").setup {} end,
  },
}
