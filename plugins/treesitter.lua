---@diagnostic disable: inject-field
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "rrethy/nvim-treesitter-textsubjects",
      -- {
      --   "IndianBoy42/tree-sitter-just",
      --   config = function() require("tree-sitter-just").setup {} end,
      -- },
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
    config = function(_, opts)
      require("nvim-treesitter.parsers").get_parser_configs().just = {
        install_info = {
          url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main",
          use_makefile = true, -- this may be necessary on MacOS (try if you see compiler errors)
        },
        maintainers = { "@IndianBoy42" },
      }
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = { useDefaultKeymaps = true },
  },
}
