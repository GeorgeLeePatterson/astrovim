return {
  -- [[ LSP ]]
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "jsonls",
        })
      return opts
    end,
  },

  -- [[ Treesitter ]]
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
      end
      return opts
    end,
  },

  -- [[ Linting / Formatting ]]

  -- Mason-null-ls
  {
    "jababu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("user.utils").list_insert_unique(
        opts.ensure_installed,
        { "jsonlint" }
      )
      return opts
    end,
  },

  -- Nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        linters_by_ft = {
          ["json"] = { "jsonlint" },
        },
      })
    end,
  },

  -- yaml schema support
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        -- make sure mason installs the server
        servers = {
          jsonls = {
            -- lazy-load schemastore when needed
            on_new_config = function(new_config)
              new_config.settings.json.schemas = new_config.settings.json.schemas
                or {}
              vim.list_extend(
                new_config.settings.json.schemas,
                require("schemastore").json.schemas()
              )
            end,
            settings = {
              json = {
                format = {
                  enable = true,
                },
                validate = { enable = true },
              },
            },
          },
        },
      })
    end,
  },
}
