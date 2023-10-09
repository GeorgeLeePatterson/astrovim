-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
local utils = require "astronvim.utils"
local telescope_themes = require "telescope.themes"
local user_utils = require "user.utils"
local alpha_config = require "user.plugins.config.alpha"
local is_available = utils.is_available

local maps = {
  n = {
    -- navigate buffer tabs with `H` and `L`
    -- L = {
    --   function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
    --   desc = "Next buffer",
    -- },
    -- H = {
    --   function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
    --   desc = "Previous buffer",
    -- },
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

    -- Telescope Overrides
    ["<leader>fi"] = {
      function() require("telescope.builtin").lsp_implementations() end,
      desc = "Find implementations",
    },
    ["<leader>fd"] = {
      function() require("telescope.builtin").diagnostics(telescope_themes.get_dropdown { bufnr = 0, winblend = 5 }) end,
      desc = "Show current diagnostics",
    },
    ["<leader>fD"] = {
      function() require("telescope.builtin").diagnostics(telescope_themes.get_ivy { winblend = 5 }) end,
      desc = "Show all diagnostics",
    },
    ["<leader>fr"] = { function() require("telescope.builtin").lsp_references() end, desc = "Show references" },
    ["<leader>fR"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" },

    -- NeoTree
    ["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
    ["<leader>o"] = {
      function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd.wincmd "p"
        else
          vim.cmd.Neotree "focus"
        end
      end,
      desc = "Toggle Explorer Focus",
    },

    --
    -- ADDITIONAL COMMANDS
    --

    -- quick save
    ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command

    -- Alpha
    -- open dashboard after closing all buffers
    ["<leader>c"] = {
      function()
        local bufs = vim.fn.getbufinfo { buflisted = true }
        require("astronvim.utils.buffer").close(0)
        if require("astronvim.utils").is_available "alpha-nvim" and not bufs[2] then
          if not pcall(function() require("alpha").start(false) end) then vim.notify "Error opening dashboard" end
        end
      end,
      desc = "Close buffer",
    },

    -- overwrite astronvim keymap if is_available "alpha-nvim" then
    ["<leader>h"] = {
      function()
        local wins = vim.api.nvim_tabpage_list_wins(0)
        if #wins > 1 then
          for win = 1, #wins do
            local buf = vim.api.nvim_win_get_buf(wins[win])
            local usable = vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "neo-tree"
              and vim.api.nvim_get_option_value("filetype", { buf = buf }) ~= "notify"
            if usable then
              vim.fn.win_gotoid(wins[win]) -- go to non-neo-tree window to toggle alpha
              break
            end
          end
        end
        require("alpha").start(false, alpha_config.configure())
      end,
      desc = "Home Screen",
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
    ["<leader>m7"] = { function() vim.cmd [[colorscheme horizon]] end, desc = "Horizon" },
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
    -- Nightfox
    ["<leader>mj"] = { name = "Nightfox" },
    ["<leader>mj0"] = { function() vim.cmd [[colorscheme nightfox]] end, desc = "Nightfox" },
    ["<leader>mj1"] = { function() vim.cmd [[colorscheme dayfox]] end, desc = "Dayfox (light)" },
    ["<leader>mj2"] = { function() vim.cmd [[colorscheme dawnfox]] end, desc = "Dawnfox (light)" },
    ["<leader>mj3"] = { function() vim.cmd [[colorscheme duskfox]] end, desc = "Duskfox" },
    ["<leader>mj4"] = { function() vim.cmd [[colorscheme nordfox]] end, desc = "Nordfox" },
    ["<leader>mj5"] = { function() vim.cmd [[colorscheme terafox]] end, desc = "Terafox" },
    ["<leader>mj6"] = { function() vim.cmd [[colorscheme carbonfox]] end, desc = "Carbonfox" },

    -- Lspsaga
    ["<leader>v"] = { name = "View More" },

    -- Wezterm
    ["<leader>W"] = { name = " Wezterm" },
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

-- Sessions
-- NOTE: Resession allows sending "dir" into `load` but it doesn't even use it when "listing" *smh*
if is_available "resession.nvim" then
  maps.n["<leader>SF"] = {
    function() require("resejssion").load(nil, { dir = "dirsession", reset = true }) end,
    desc = "Load a DIR session",
  }
end

-- Map buffer view to flubuf
if is_available "flybuf.nvim" then
  maps.n["<leader>bb"] = { function() vim.cmd [[FlyBuf]] end, desc = "View Buffers" }
end

-- Disable Heirline Buffers and Tabs
maps.n["<leader>bd"] = false
maps.n["<leader>b\\"] = false
maps.n["<leader>b|"] = false

-- AI
maps.n = vim.tbl_extend("force", maps.n, {
  ["<leader>A"] = { name = " AI" },
  ["<leader>At"] = {
    function()
      local tn_ok, _ = pcall(require, "tabnine")
      if tn_ok then
        vim.cmd [[TabnineToggle]]
        vim.cmd [[TabnineStatus]]
      end
    end,

    desc = "Toggle Tabnine",
  },
  ["<leader>Acd"] = {
    function()
      local tn_ok, _ = pcall(require, "copilot")
      if tn_ok then
        vim.cmd [[Copilot disable]]
        vim.cmd [[Copilot status]]
      end
    end,

    desc = "Disable Copilot",
  },
})

return maps
