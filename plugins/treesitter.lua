---@diagnostic disable: inject-field
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "rrethy/nvim-treesitter-textsubjects",
{
    "chrisgrieser/nvim-various-textobjs",
    opts = { useDefaultKeymaps = true },
  }
    },
    opts = function(_, opts)
      return vim.tbl_extend("force", opts, {
        auto_install = true,
        ensure_installed = require("user.utils").list_insert_unique(
          opts.ensure_installed,
          {
            "bash",
            "hcl",
            "json",
            "make",
            "regex",
            "sql",
            "terraform",
            "vim",
            "yaml",
          }
        ),
        textsubjects = {
          enable = true,
          prev_selection = ",",
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
          },
        },

        highlight = {
          disable = function(_lang, buf)
            local max_filesize = 1024 * 1024 -- 1 MB
            local ok, stats =
              pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then return true end
          end,
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
}
