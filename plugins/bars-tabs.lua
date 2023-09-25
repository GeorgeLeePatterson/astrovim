local bufferline_opts = require("user.config").bufferline

return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = bufferline_opts,
    event = "VeryLazy",
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = "VeryLazy",
    opts = {
      highlight = true,
      click = true,
    },
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      {
        "SmiteshP/nvim-navic",
      },
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
          "nvim-telescope/telescope.nvim", -- Optional
        },
        opts = { lsp = { auto_attach = true } },
      },
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = function(_, opts)
      require("barbecue").setup(vim.tbl_deep_extend("force", opts, {
        -- attach_navic = false,
        -- Improves speed
        create_autocmd = false,
      }))

      -- Improves speed
      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function() require("barbecue.ui").update() end,
      })
    end,
  },
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
