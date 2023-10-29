return {
  -- [[ LSP ]]
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "cssls",
          "html",
          "tsserver",
        })
      return opts
    end,
  },
  -- [[ Treesitter ]]
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "css",
          "html",
          "javascript",
          "scss",
          "typescript",
          "tsx",
        })
      return opts
    end,
  },

  -- [[ Linting / Formatting ]]

  -- Conform
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        formatters_by_ft = {
          ["javascript"] = { "prettier" },
          ["javascriptreact"] = { "prettier" },
          ["typescript"] = { "prettier" },
          ["typescriptreact"] = { "prettier" },
          ["vue"] = { "prettier" },
          ["css"] = { "prettier" },
          ["scss"] = { "prettier" },
          ["less"] = { "prettier" },
          ["html"] = { "prettier" },
          ["graphql"] = { "prettier" },
        },
      })
    end,
  },

  -- Tsc
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    keys = {},
    config = function(_, opts) require("tsc").setup(opts) end,
  },

  -- Mason-null-ls
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "eslint_d",
          "prettier",
          "stylelint",
        })
      return opts
    end,
  },

  -- None-ls
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require "null-ls"
      return vim.tbl_deep_extend("force", opts, {
        on_attach = require("astronvim.utils.lsp").on_attach,
        sources = require("user.utils").list_insert_unique(opts.sources, {
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.diagnostics.tsc,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylelint,

          -- -- Transition to this usage:
          -- null_ls.builtins.formatting.prettier.with({
          -- 	condition = function()
          -- 		return vim.fn.executable("prettier") > 0 or vim.fn.executable("./node_modules/.bin/prettier") > 0
          -- 	end,
          -- }),
          -- null_ls.builtins.diagnostics.eslint.with({
          -- 	condition = function()
          -- 		vim.o.fixendofline = true -- Error: [prettier/prettier] Insert `⏎`
          -- 		return vim.fn.executable("eslint") > 0 or vim.fn.executable("./node_modules/.bin/eslint") > 0
          -- 	end,
          -- }),
        }),
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
          javascript = { "eslint_d" },
          typescript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          typescriptreact = { "eslint_d" },
          svelte = { "eslint_d" },
        },
      })
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cR",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "Remove Unused Imports",
            },
          },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
    },
  },
  -- {
  --   "mfussenegger/nvim-dap",
  --   dependencies = {
  --     {
  --       "williamboman/mason.nvim",
  --       opts = function(_, opts)
  --         opts.ensure_installed = opts.ensure_installed or {}
  --         table.insert(opts.ensure_installed, "js-debug-adapter")
  --       end,
  --     },
  --   },
  --   opts = function()
  --     local dap = require "dap"
  --     if not dap.adapters["pwa-node"] then
  --       require("dap").adapters["pwa-node"] = {
  --         type = "server",
  --         host = "localhost",
  --         port = "${port}",
  --         executable = {
  --           command = "node",
  --           -- 💀 Make sure to update this path to point to your installation
  --           args = {
  --             require("mason-registry").get_package("js-debug-adapter"):get_install_path()
  --               .. "/js-debug/src/dapDebugServer.js",
  --             "${port}",
  --           },
  --         },
  --       }
  --     end
  --     for _, language in ipairs { "typescript", "javascript", "typescriptreact", "javascriptreact" } do
  --       if not dap.configurations[language] then
  --         dap.configurations[language] = {
  --           {
  --             type = "pwa-node",
  --             request = "launch",
  --             name = "Launch file",
  --             program = "${file}",
  --             cwd = "${workspaceFolder}",
  --           },
  --           {
  --             type = "pwa-node",
  --             request = "attach",
  --             name = "Attach",
  --             processId = require("dap.utils").pick_process,
  --             cwd = "${workspaceFolder}",
  --           },
  --         }
  --       end
  --     end
  --   end,
  -- },
}

-- return {
--   {
--     "pmizio/typescript-tools.nvim",
--     dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
--     opts = {},
--     config = function(_, opts)
--       require("typescript-tools").setup(vim.tbl_deep_extend("force", opts, {
--         settings = {
--           tsserver_plugins = {
--             "@styled/typescript-styled-plugin",
--           },
--         },
--       }))
--     end,
--   },
-- }
