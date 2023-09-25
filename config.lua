return {
  defaults = {
    theme = {
      light = "github_light",
      dark = "horizon",
    },
    background = "dark",
    background_toggle = false,
    zen = false,
  },
  favorite_themes = { "gruvbox", "horizon", "github_dark", "midnight" },
  bufferline = {
    options = {
      offsets = {
        { filetype = "neo-tree", text = "File Explorer", highlight = "NeoTreeNormal", padding = 0 },
      },
      themable = true,
      indicator = {
        icon = " ",
        style = "icon",
      },
      separator_style = "slope",
    },
  },
  custom_highlights = {
    dashboard = {

      -- Dashboard colors
      StartLogo1 = { ctermfg = 18, fg = "#14067E" },
      StartLogo2 = { ctermfg = 18, fg = "#15127B" },
      StartLogo3 = { ctermfg = 18, fg = "#171F78" },
      StartLogo4 = { ctermfg = 18, fg = "#182B75" },
      StartLogo5 = { ctermfg = 23, fg = "#193872" },
      StartLogo6 = { ctermfg = 23, fg = "#1A446E" },
      StartLogo7 = { ctermfg = 23, fg = "#1C506B" },
      StartLogo8 = { ctermfg = 23, fg = "#1D5D68" },
      StartLogo9 = { ctermfg = 23, fg = "#1E6965" },
      StartLogo10 = { ctermfg = 29, fg = "#1F7562" },
      StartLogo11 = { ctermfg = 29, fg = "#21825F" },
      StartLogo12 = { ctermfg = 29, fg = "#228E5C" },
      StartLogo13 = { ctermfg = 35, fg = "#239B59" },
      StartLogo14 = { ctermfg = 35, fg = "#24A755" },
      StartLogo15 = { ctermfg = 35, fg = "#26B352" },
      StartLogo16 = { ctermfg = 35, fg = "#27C04F" },
      StartLogo17 = { ctermfg = 41, fg = "#28CC4C" },
      StartLogo18 = { ctermfg = 41, fg = "#29D343" },
      StartLogoPop1 = { ctermfg = 214, fg = "#EC9F05" },
      StartLogoPop2 = { ctermfg = 208, fg = "#F08C04" },
      StartLogoPop3 = { ctermfg = 208, fg = "#F37E03" },
      StartLogoPop4 = { ctermfg = 202, fg = "#F77002" },
      StartLogoPop5 = { ctermfg = 202, fg = "#FB5D01" },
      StartLogoPop6 = { ctermfg = 202, fg = "#FF4E00" },
    },
  },
}
