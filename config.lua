return {
  defaults = {
    theme = {
      light = "github_light",
      dark = "horizon",
    },
    background = "light", -- "dark",
    background_toggle = false,
    zen = false,
  },
  favorite_themes = {
    "mellifluous",
    -- "gruvbox",
    -- "horizon",
    -- ["github-nvim-theme"] = { "github_dark", "github_light" },
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
      diagnostics_update_in_insert = true,
      show_tab_indicators = true,
      separator_style = "slope",
      diagnostics = "nvim_lsp",
    },
  },
  icons = {
    diagnostics = { Error = "✘", Warn = "", Hint = "i", Info = "i" },
    git = {
      Add = "+",
      Change = "~",
      Delete = "-",
    },
    kinds = {
      -- LspKind symbols must go first :eye-roll:
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰜢",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "",
      -- Additional
      Array = "󰅪",
      Branch = "",
      Boolean = "◩",
      Key = "",
      Namespace = "󰅩",
      Number = "󰎠",
      Null = "󰟢",
      Object = "⦿",
      Package = "󰏗",
      String = "𝓐",
      Copilot = "",
    },
    cmp_sources = {
      nvim_lsp = "✨",
      luasnip = "🚀",
      buffer = "📝",
      path = "📁",
      cmdline = "💻",
      nvim_lua = "🌗",
      copilot_cmp = "🧠",
    },
    statusline = {
      Error = "❗",
      Warn = "⚠️ ",
      Hint = "i",
      Info = "💡",
    },
  },
}
