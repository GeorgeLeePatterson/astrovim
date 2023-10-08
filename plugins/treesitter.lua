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
    opts = function(_, opts)
      return require("astronvim.utils").extend_tbl(opts, {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      })
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
