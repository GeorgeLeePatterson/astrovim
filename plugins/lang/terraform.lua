return {
  -- [[ LSP ]]
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "terraformls",
          "tflint",
        })
      return opts
    end,
  },

  -- [[ Linting / Formatting ]]

  -- Mason-null-ls
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "terraform",
        })
      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {},
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require "null-ls"
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.formatting.terraform_fmt,
        nls.builtins.diagnostics.terraform_validate,
      })
      return opts
    end,
  },

  -- [[ Treesitter ]
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "terraform",
          "hcl",
        })
      end
      return opts
    end,
  },
}
