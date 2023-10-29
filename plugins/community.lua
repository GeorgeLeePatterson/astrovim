-- TODO: Move out from `community`
-- Don't really want some of these core plugins here like this...

return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.motion/nvim-surround" },
  { "AstroNvim/astrotheme", enabled = false },
}
