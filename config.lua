return {
  defaults = {
    theme = {
      light = "github_light",
      dark = "github_dark",
    },
    background = "dark",
    background_toggle = false,
  },
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
}
