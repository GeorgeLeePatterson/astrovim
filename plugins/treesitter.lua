return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "rrethy/nvim-treesitter-textsubjects",
    },
    opts = function(_, opts)
      return vim.tbl_extend("force", opts, {
        auto_install = true,
        ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
          "lua",
          "bash",
          "css",
          "html",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "rust",
          "toml",
          "typescript",
          "vim",
        }),
        textsubjects = {
          enable = true,
          prev_selection = ",",
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
          },
        },
      })
    end,
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    -- opts = function(_, opts)
    --   return require("astronvim.utils").extend_tbl(opts, {
    --     space_char_blankline = " ",
    --     show_current_context = true,
    --     show_current_context_start = true,
    --   })
    -- end,
    config = function(_, opts)
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup(vim.tbl_deep_extend("force", opts, { scope = { highlight = highlight } }))

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = { useDefaultKeymaps = true },
  },
  {
    "IndianBoy42/tree-sitter-just",
    config = function() require("tree-sitter-just").setup() end,
  },
}
