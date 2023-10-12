-- TODO: Move out from `community`
-- Don't really want some of these core plugins here like this...

return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.rust" },
  {
    "simrat39/rust-tools.nvim",
    config = require("user.plugins.config.rust-tools").setup,
  },
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
