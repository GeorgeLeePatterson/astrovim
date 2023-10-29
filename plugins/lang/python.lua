return {
  -- [[ LSP ]]
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "pyright",
        })
    end,
  },

  -- [[ Treesitter ]]
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = require("user.utils").list_insert_unique(
        opts.ensure_installed,
        { "python" }
      )
    end,
  },

  -- [[ Linting / Formatting ]]

  -- Mason-null-ls
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "black",
          "isort",
          "pylint",
        })
      return opts
    end,
  },

  -- None-ls
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      -- local nls = require "null-ls"
      opts.sources = vim.list_extend(opts.sources or {}, {
        -- TODO
      })
    end,
  },

  -- Conform
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        formatters_by_ft = {
          ["python"] = { "isort", "black" },
        },
      })
    end,
  },

  -- Nvim-lint
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        linters_by_ft = {
          python = { "pylint" },
        },
      })
    end,
  },
}
