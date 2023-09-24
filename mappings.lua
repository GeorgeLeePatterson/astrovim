-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
local utils = require "astronvim.utils"
local user_utils = require "user.utils"
local is_available = utils.is_available

local maps = {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map

    -- navigate buffer tabs with `H` and `L`
    L = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    H = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },
    ["<leader>fF"] = { ":Telescope file_browser<CR>", desc = "Open File Browser" },
    ["<leader>fz"] = { ":Telescope zoxide list<CR>", desc = "Open Zoxide List" },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },

    --
    -- ADDITIONAL COMMANDS
    --

    -- quick save
    ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command

    -- open dashboard after closing all buffers
    ["<leader>c"] = {
      function()
        local bufs = vim.fn.getbufinfo { buflisted = true }
        require("astronvim.utils.buffer").close(0)
        if require("astronvim.utils").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
      end,
      desc = "Close buffer",
    },

    -- Toggle lsp lines
    ["<leader>le"] = { require("lsp_lines").toggle, desc = "Toggle Error Overlay" },

    -- Light/Dark mode
    ["<leader>m0"] = {
      function() user_utils.set_background_and_theme "dark" end,
      desc = "Dark Mode",
    },
    ["<leader>m1"] = {
      function() user_utils.set_background_and_theme "light" end,
      desc = "Light Mode",
    },
    -- THEMES
    ["<leader>m"] = { name = " Themes" },
    ["<leader>m2"] = { function() vim.cmd [[colorscheme midnight]] end, desc = "Midnight" },
    ["<leader>m3"] = { function() vim.cmd [[colorscheme onedark]] end, desc = "OneDark" },
    ["<leader>m4"] = { function() vim.cmd [[colorscheme oxocarbon]] end, desc = "Oxocarbon" },
    ["<leader>m5"] = { function() vim.cmd [[colorscheme Tokyodark]] end, desc = "TokyoDark" },
    ["<leader>m6"] = { function() vim.cmd [[colorscheme gruvbox]] end, desc = "Gruvbox" },
    -- Monokai Variations
    ["<leader>ma"] = { name = "Monokai" },
    ["<leader>ma0"] = { function() vim.cmd [[colorscheme monokai-pro-default]] end, desc = "Default" },
    ["<leader>ma1"] = { function() vim.cmd [[colorscheme monokai-pro-classic]] end, desc = "Classic" },
    ["<leader>ma2"] = { function() vim.cmd [[colorscheme monokai-pro-machine]] end, desc = "Machine" },
    ["<leader>ma3"] = { function() vim.cmd [[colorscheme monokai-pro-octagon]] end, desc = "Octagon" },
    ["<leader>ma4"] = { function() vim.cmd [[colorscheme monokai-pro-spectrum]] end, desc = "Spectrum" },
    ["<leader>ma5"] = { function() vim.cmd [[colorscheme monokai-pro-ristretto]] end, desc = "Ristretto" },
    -- TokyoNight Variations
    ["<leader>ms"] = { name = "TokyoNight" },
    ["<leader>ms0"] = { function() vim.cmd [[colorscheme tokyonight]] end, desc = "Default" },
    ["<leader>ms1"] = { function() vim.cmd [[colorscheme tokyonight-day]] end, desc = "Day" },
    ["<leader>ms2"] = { function() vim.cmd [[colorscheme tokyonight-moon]] end, desc = "Moon" },
    ["<leader>ms3"] = { function() vim.cmd [[colorscheme tokyonight-night]] end, desc = "NightNight" },
    ["<leader>ms4"] = { function() vim.cmd [[colorscheme tokyonight-storm]] end, desc = "Storm" },
    -- Catppuccin Variations
    ["<leader>md"] = { name = "Catppuccin" },
    ["<leader>md0"] = { function() vim.cmd [[colorscheme catppuccin-latte]] end, desc = "Latte" },
    ["<leader>md1"] = { function() vim.cmd [[colorscheme catppuccin-frappe]] end, desc = "Frappe" },
    ["<leader>md2"] = { function() vim.cmd [[colorscheme catppuccin-macchiato]] end, desc = "Macchiato" },
    ["<leader>md3"] = { function() vim.cmd [[colorscheme catppuccin-mocha]] end, desc = "Mocha" },
    -- Github Variations
    ["<leader>mf"] = { name = "Github" },
    ["<leader>mf0"] = { function() vim.cmd [[colorscheme github_dark]] end, desc = "Dark" },
    ["<leader>mf1"] = {
      function() vim.cmd [[colorscheme github_dark_dimmed]] end,
      desc = "Dark Dimmed",
    },
    ["<leader>mf2"] = {
      function() vim.cmd [[colorscheme github_dark_high_contrast]] end,
      desc = "Dark High Contrast",
    },
    ["<leader>mf3"] = { function() vim.cmd [[colorscheme github_light]] end, desc = "Light" },
    ["<leader>mf4"] = {
      function() vim.cmd [[colorscheme github_light_high_contrast]] end,
      desc = "Light High Contrast",
    },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}

-- ZenMode
maps.n["zZ"] = {
  function() require("zen-mode").toggle() end,
  desc = "Zen Mode",
}
-- Devdocs rust
maps.n["<leader>f?"] = {
  function()
    if is_available "nvim-devdocs" then vim.cmd [[DevdocsOpenFloat rust]] end
  end,
  desc = "Open Rust docs",
}

-- Git blame
maps.n["<leader>gi"] = {
  function() require("blame").toggle "virtual" end,
  desc = "Git blame inline",
}

-- Map buffer view to flubuf
if is_available "flybuf.nvim" then
  maps.n["<leader>bb"] = { function() vim.cmd [[FlyBuf]] end, desc = "View Buffers" }
end

-- Disable Heirline Buffers and Tabs
maps.n["<leader>bd"] = false
maps.n["<leader>b\\"] = false
maps.n["<leader>b|"] = false

return maps
