local config = {
  defaults = {
    -- Only used if auto-dark-mode is enabled
    theme = {
      light = "dayfox",
      dark = "gruvbox",
    },
    background = "dark",
    background_toggle = false,
    -- Whether to turn zen on at startup
    zen = false,
  },

  -- [[ Language Plugins ]]
  languages = {
    "json",
    "lua",
    "markdown",
    "python",
    "rust",
    "typescript",
  },

  -- [[ Linters / Formatters ]]
  linters = {
    lua = { "selene" },
  },

  -- [[ AI Plugins ]]
  ai = {
    -- Use this if you want to load one over the other. Remember to run
    -- `Copilot auth` for copilot and `TabnineHub` for tabnine before using.
    copilot = true,
    tabnine = true,
  },

  -- [[ Colorscheme setup ]]
  colorscheme = {
    debug = false,
    favorite_themes = {
      -- -- The loader uses the key (if k/v) or name to configure the theme.
      -- -- If the name of the theme you want to randomly load is different
      -- -- from the name of its plugin, them use the format below.
      -- ["github-nvim-theme"] = { "github_dark", "github_light" },

      -- -- More examples of some themes
      -- "mellifluous",
      -- "tokyonight",
      -- "bluloco",
      -- "nightfox",

      -- Default themes. Keep, delete, add, whatever you want.
      "gruvbox",
    },
  },

  -- [[ Ui ]]
  ui = {
    -- Used throughout to change layouts of telescope and other plugins
    breakpoint = 200,
  },

  -- [[ Mappings ]]
  mappings = {
    icons = {
      favorite = "⭐️",
    },
  },

  -- [[ Icons ]]
  icons = {
    diagnostics = {
      Error = "✘ ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
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

  -- [[ Cmp ]]
  cmp = {
    kind_priority = {
      TabNine = 15,
      Copilot = 15,
      Module = 14,
      Field = 13,
      Function = 12,
      Method = 12,
      Struct = 11,
      Property = 11,
      Constant = 10,
      Enum = 10,
      Interface = 10,
      EnumMember = 10,
      Event = 10,
      Operator = 10,
      Reference = 10,
      Variable = 9,
      File = 8,
      Folder = 8,
      Class = 5,
      Color = 5,
      Keyword = 2,
      Constructor = 1,
      Text = 1,
      TypeParameter = 1,
      Unit = 1,
      Value = 1,
      Snippet = 0,
    },
  },
}

local mappings = config["mappings"] or {}

-- Favorite a keymap
mappings["favorite"] = function(desc)
  if type(desc) == "table" then desc = desc["desc"] or "" end
  config["mappings"] = mappings
  return desc .. " " .. config.mappings.icons.favorite
end

-- Get a nested value
config.get_config = function(path)
  local temp = config
  for hop in path:gmatch "([^%.]+)" do
    temp = temp[hop] or {}
  end
  return temp
end

return config
