-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
local utils = require "astronvim.utils"
local telescope_themes = require "telescope.themes"
local user_utils = require "user.utils"
local alpha_config = require "user.plugins.config.alpha"
local theme_config = require "user.plugins.config.theme"
local is_available = utils.is_available
-- local buffer_utils = require "user.utils.buffer"

local maps = {
  n = {
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

    -- [[ NeoTree ]]
    -- ["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
    ["<leader>o"] = {
      function()
        if vim.bo.filetype == "neo-tree" then
          local ok, edgy = pcall(require, "edgy")
          if ok then
            edgy.goto_main()
          else
            vim.cmd.wincmd "p"
          end
        else
          vim.cmd.Neotree "focus"
        end
      end,
      desc = "Toggle Explorer Focus",
    },

    --
    -- ADDITIONAL COMMANDS
    --

    ["<leader>r"] = { name = "󰩨 Resize" },
    ["<leader>rh"] = { function() vim.cmd [[vertical resize -10<cr>]] end, desc = "Resize -10 l/r" },
    ["<leader>rl"] = { function() vim.cmd [[vertical resize +10<cr>]] end, desc = "Resize +10 l/r" },
    ["<leader>rj"] = { function() vim.cmd [[horizontal resize -10<cr>]] end, desc = "Resize -10 u/d" },
    ["<leader>rk"] = { function() vim.cmd [[horizontal resize +10<cr>]] end, desc = "Resize +10 u/d" },

    -- quick save
    ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command

    -- Alpha
    -- open dashboard after closing all buffers
    ["<leader>c"] = {
      function()
        local bufs = vim.fn.getbufinfo { buflisted = true }
        local alpha_available = require("astronvim.utils").is_available "alpha-nvim"
        local is_alpha = vim.api.nvim_get_option_value("filetype", { scope = "local" }) ~= "alpha"
        -- If alpha is the only window, don't close
        if is_alpha and not bufs[2] then return end

        -- Close window
        require("astronvim.utils.buffer").close(0)

        if alpha_available and not bufs[2] then
          if not pcall(function() require("alpha").start(true) end) then vim.notify "Error opening dashboard" end
        end
      end,
      desc = "Close buffer",
    },

    -- overwrite astronvim keymap if is_available "alpha-nvim" then
    ["<leader>h"] = {
      function()
        local ok, edgy = pcall(require, "edgy")
        if ok then
          edgy.goto_main()
          require("alpha").start(false, alpha_config.configure())
        end
      end,
      desc = "Dashboard",
    },

    -- Light/Dark mode
    ["<leader>m0"] = {
      function() user_utils.set_background_and_theme "dark" end,
      desc = "Dark Mode",
    },
    ["<leader>m1"] = {
      function() user_utils.set_background_and_theme "light" end,
      desc = "Light Mode",
    },

    -- Noice
    ["<leader>N"] = { name = "󰍨 Noice" },

    -- Spectre
    ["<leader>s"] = { name = "󰬲 Search & Replace" },

    -- Lspsaga
    ["<leader>v"] = { name = " View More" },

    -- Wezterm
    ["<leader>W"] = { name = " Wezterm" },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}

-- Themes
maps = theme_config.mappings(maps)

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

-- [[ Telescope ]]
maps.n["<leader>O"] = {
  function()
    require("telescope.builtin").oldfiles(telescope_themes.get_dropdown { initial_mode = "normal", winblend = 5 })
  end,
  desc = "Recent Files",
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

-- Toggle lsp lines
if is_available "lsp_lines" then
  maps.n["<leader>le"] = { require("lsp_lines").toggle, desc = "Toggle Error Overlay" }
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
