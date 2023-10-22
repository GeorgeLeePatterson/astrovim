-- TODO: Move out from `community`
-- Don't really want some of these core plugins here like this...

return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.motion/nvim-surround" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },
  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
}
