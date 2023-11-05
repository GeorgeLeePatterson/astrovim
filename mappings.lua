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

local user_config = require "user.config"
local favorite = user_config.get_config "mappings.favorite"
  or function(name) return name end

local maps = {
  n = {
    -- [[ Convenience ]]
    ["cd"] = {
      function() require("user.utils.telescope").telescope_find_dir() end,
      desc = "[c]hange [d]irectory",
    },

    -- [[ Buffer ]]

    ["<leader>b"] = { name = "Buffers" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "[D]elete buffer",
    },

    -- [[ Telescope ]]

    -- File/Folders
    ["<leader>fF"] = {
      function()
        require("telescope").extensions.file_browser.file_browser {
          files = false,
          hijack_netrw = true,
          grouped = true,
          hidden = { file_browser = true, folder_browser = false },
          prompt_path = true,
          depth = 2,
        }
      end,
      desc = "[F]older Browser",
    },
    ["<leader>fz"] = {
      ":Telescope zoxide list<CR>",
      desc = "[z]oxide List",
    },

    -- Find strings
    ["<leader>fc"] = {
      function() require("telescope.builtin").grep_string() end,
      desc = "Find word under cursor",
    },

    -- lsp
    ["<leader>fi"] = {
      function() require("telescope.builtin").lsp_implementations() end,
      desc = favorite "Find [i]mplementations",
    },
    ["<leader>fd"] = {
      function()
        require("telescope.builtin").diagnostics(
          telescope_themes.get_dropdown { bufnr = 0, winblend = 5 }
        )
      end,
      desc = "[d]iagnostics",
    },
    ["<leader>fD"] = {
      function()
        require("telescope.builtin").diagnostics(
          telescope_themes.get_ivy { winblend = 5 }
        )
      end,
      desc = favorite "[f]ind all [D]iagnostics",
    },
    ["<leader>fr"] = {
      function() require("telescope.builtin").lsp_references() end,
      desc = favorite "[r]eferences",
    },
    ["<leader>fR"] = {
      function() require("telescope.builtin").registers() end,
      desc = "[R]egisters",
    },

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
          vim.cmd [[Neotree action=focus]]
        end
      end,
      desc = favorite "T[o]ggle Explorer Focus",
    },

    --
    -- ADDITIONAL COMMANDS
    --

    ["<leader>r"] = { name = "󰩨 Resize" },
    ["<leader>rh"] = {
      function() vim.cmd [[vertical resize -10<cr>]] end,
      desc = "Resize -10 [h]",
    },
    ["<leader>rl"] = {
      function() vim.cmd [[vertical resize +10<cr>]] end,
      desc = "Resize +10 [l]",
    },
    ["<leader>rj"] = {
      function() vim.cmd [[horizontal resize -10<cr>]] end,
      desc = "Resize -10 [j]",
    },
    ["<leader>rk"] = {
      function() vim.cmd [[horizontal resize +10<cr>]] end,
      desc = "Resize +10 [k]",
    },

    -- quick save
    ["<C-s>"] = { ":w!<cr>", desc = "[s]ave File" }, -- change description but the same command

    -- close
    ["<leader>c"] = {
      function()
        -- local bufs = vim.fn.getbufinfo { buflisted = true }
        local file_bufs = user_utils.get_file_bufs() or {}
        local alpha_available, alpha = pcall(require, "alpha")
        local is_alpha = vim.api.nvim_get_option_value(
          "filetype",
          { scope = "local" }
        ) == "alpha"

        -- If alpha is the only window, don't close
        if is_alpha and not file_bufs[1] then return end

        -- Go to main window
        local ok, edgy = pcall(require, "edgy")
        if ok then edgy.goto_main() end

        -- Close window
        require("astronvim.utils.buffer").close(0)

        if alpha_available and not is_alpha and not file_bufs[1] then
          -- open dashboard after closing all buffers
          alpha.start(false, alpha_config())
        end
      end,
      desc = "[c]lose buffer",
    },

    -- overwrite astronvim keymap if is_available "alpha-nvim" then
    ["<leader>h"] = {
      function()
        local file_bufs = user_utils.get_file_bufs()
        local is_alpha = vim.api.nvim_get_option_value(
          "filetype",
          { scope = "local" }
        ) == "alpha"

        if is_alpha and #file_bufs == 0 then return end
        local ok, edgy = pcall(require, "edgy")
        if ok and not is_alpha then
          edgy.goto_main()
          require("alpha").start(false, alpha_config())
        end
      end,
      desc = "[h]ome",
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
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  v = {
    ["<leader>fc"] = {
      function() require("user.utils.telescope").telescope_search_selection() end,
      desc = "Find word under cursor",
    },
  },
}

-- [[ Add addition sections ]]

local add_description = function(mapping, key, desc, mod)
  mapping = mapping or {}
  if mod ~= nil then
    if not is_available(mod) then return end
  end
  mapping[key] = { name = desc }
  return mapping
end

-- Fzf
maps.n = add_description(maps.n, "<leader>j", favorite "󰑯 Fzf")
maps.v = add_description(maps.v, "<leader>j", favorite "󰑯 Fzf")

-- Noice
maps.n = add_description(maps.n, "<leader>N", "󰍨 Noice")
maps.v = add_description(maps.v, "<leader>N", "󰍨 Noice")

-- Spectre
maps.n = add_description(maps.n, "<leader>s", "󰬲 Search & Replace")
maps.v = add_description(maps.v, "<leader>s", "󰬲 Search & Replace")

-- Lspsaga
maps.n = add_description(maps.n, "<leader>v", favorite " View More")
maps.v = add_description(maps.v, "<leader>v", favorite " View More")

-- Wezterm
maps.n = add_description(maps.n, "<leader>W", favorite " Wezterm")

-- [[ Better J & K ]]

local better_j = {
  function() return vim.v.count > 0 and "j" or "gj" end,
  noremap = true,
  expr = true,
  desc = "Better [j]",
}
local better_k = {
  function() return vim.v.count > 0 and "k" or "gk" end,
  noremap = true,
  expr = true,
  desc = "Better [k]",
}
maps.n = vim.tbl_extend("force", maps.n, { j = better_j, k = better_k })
maps.x = vim.tbl_extend("force", maps.x or {}, { j = better_j, k = better_k })

-- [[ Themes ]]
maps = theme_config.mappings(maps)

-- [[ ZenMode ]]
maps.n["zZ"] = {
  function() require("zen-mode").toggle() end,
  desc = favorite "[Z]en Mode",
}
-- [[ Devdocs ]]
maps.n["<leader>f?"] = {
  function()
    if is_available "nvim-devdocs" then vim.cmd [[DevdocsOpenFloat rust]] end
  end,
  desc = "🦀 Rust docs",
}

-- [[ Telescope ]]
maps.n["<leader>O"] = {
  function()
    require("telescope.builtin").oldfiles(
      telescope_themes.get_dropdown { initial_mode = "normal", winblend = 5 }
    )
  end,
  desc = favorite "[O]ld Files",
}

-- [[ Sessions ]]

-- Resession
-- NOTE: Resession allows sending "dir" into `load` but it doesn't even use it when "listing" *smh*
if is_available "resession.nvim" then
  maps.n["<leader>SF"] = {
    function()
      require("resejssion").load(nil, { dir = "dirsession", reset = true })
    end,
    desc = "[s]ession load [F]iles",
  }
end

-- Map buffer view to flubuf
if is_available "flybuf.nvim" then
  maps.n["<leader>bb"] =
    { function() vim.cmd [[FlyBuf]] end, desc = "[b]uffers" }
end

-- Toggle lsp lines
if is_available "lsp_lines" then
  maps.n["<leader>le"] =
    { require("lsp_lines").toggle, desc = "Toggle [e]rror Overlay" }
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

    desc = "[t]oggle Tabnine",
  },
  ["<leader>Acd"] = {
    function()
      local tn_ok, _ = pcall(require, "copilot")
      if tn_ok then
        vim.cmd [[Copilot disable]]
        vim.cmd [[Copilot status]]
      end
    end,

    desc = "[c]opilot [d]isable",
  },
})

return maps
