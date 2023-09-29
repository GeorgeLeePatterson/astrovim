local bufferline_opts = require("user.config").bufferline
local icons = require("user.config").icons

return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      opts.tabline = nil -- remove tabline
      return opts
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = bufferline_opts,
    event = "VeryLazy",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function(_, opts)
      require("lualine").setup(vim.tbl_deep_extend("force", opts, {
        extensions = {
          "aerial",
          "fugitive",
          "fzf",
          "lazy",
          "neo-tree",
          "quickfix",
          "toggleterm",
          "trouble",
        },
        global_statusline = true,
      }))
    end,
  },
  -- {
  --   "Bekaboo/dropbar.nvim",
  --   event = "BufReadPre",
  --   keys = {
  --     {
  --       "g<Tab>",
  --       function() require("dropbar.api").pick() end,
  --       mode = { "n" },
  --     },
  --   },
  --   config = function()
  --     require("dropbar").setup {
  --       manu = {
  --         icons = {
  --           kinds = icons.kinds,
  --         },
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   "SmiteshP/nvim-navic",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --   },
  --   event = "VeryLazy",
  --   opts = {
  --     highlight = true,
  --     click = true,
  --   },
  -- },
  -- {
  --   "utilyre/barbecue.nvim",
  --   name = "barbecue",
  --   version = "*",
  --   event = "VeryLazy",
  --   dependencies = {
  --     {
  --       "SmiteshP/nvim-navic",
  --     },
  --     {
  --       "SmiteshP/nvim-navbuddy",
  --       dependencies = {
  --         "SmiteshP/nvim-navic",
  --         "MunifTanjim/nui.nvim",
  --         "nvim-telescope/telescope.nvim", -- Optional
  --       },
  --       opts = { lsp = { auto_attach = true } },
  --     },
  --     "nvim-tree/nvim-web-devicons", -- optional dependency
  --   },
  --   config = function(_, opts)
  --     require("barbecue").setup(vim.tbl_deep_extend("force", opts, {
  --       -- attach_navic = false,
  --       -- Improves speed
  --       create_autocmd = false,
  --       exclude_filetypes = { "alpha", "netrw", "toggleterm", "neo-tree", "quickfix", "telescope", "" },
  --     }))
  --
  --     -- Improves speed
  --     vim.api.nvim_create_autocmd({
  --       "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
  --       "BufWinEnter",
  --       "CursorHold",
  --       "InsertLeave",
  --     }, {
  --       group = vim.api.nvim_create_augroup("barbecue.updater", {}),
  --       callback = function() local _ = pcall(require("barbecue.ui").update) end,
  --     })
  --   end,
  -- },
  -- {
  --   "romgrk/barbar.nvim",
  --   dependencies = {
  --     "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
  --     "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
  --   },
  --   init = function() vim.g.barbar_auto_setup = false end,
  --   opts = {
  --     -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
  --     -- animation = true,
  --     -- insert_at_start = true,
  --     -- …etc.
  --   },
  -- },
  -- {
  --   "nanozuki/tabby.nvim",
  --   lazy = false,
  --   opts = function() require("tabby.tabline").use_preset "active_wins_at_end" end,
  -- },
}
