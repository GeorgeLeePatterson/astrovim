return {
  defaults = {
    -- Only used if auto-dark-mode is enabled
    theme = {
      light = "github_light",
      dark = "horizon",
    },
    background = "dark",
    background_toggle = false,
    zen = false,
  },
  ai = {
    -- Use this if you want to load one over the other. Remember to run
    -- `Copilot auth` for copilot and `TabnineHub` for tabnine before using.
    copilot = true,
    tabnine = true,
  },
  colorscheme = {
    debug = false,
    favorite_themes = {
      -- -- The loader uses the key (if k/v) or name to configure the theme.
      -- -- If the name of the theme you want to randomly load is different
      -- -- from the name of its plugin, them use the format below.
      -- ["github-nvim-theme"] = { "github_dark", "github_light" },

      -- -- More examples of some themes
      -- "mellifluous",
      -- "gruvbox",
      -- "horizon",

      -- Default themes. Keep, delete, add, whatever you want.
      "bluloco",
      ["nightfox"] = { "nightfox", "nordfox" },
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
      TabNine = "",
    },
    cmp_sources = {
      nvim_lsp = "✨",
      luasnip = "🚀",
      buffer = "📝",
      path = "📁",
      cmdline = "💻",
      nvim_lua = "🌗",
      copilot = "🧠",
      cmp_tabnine = "🧠",
    },
    statusline = {
      Error = "❗",
      Warn = "⚠️ ",
      Hint = "i",
      Info = "💡",
    },
  },
}
