return {
  -- [[ LSP ]]
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "cssls",
          "cssmodules_ls",
          "eslint",
          "html",
          "tsserver",
        })
      return opts
    end,
  },

  -- Typescript-tools
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      capabilities = require("cmp_nvim_lsp").update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      ),
      on_attach = function(client, bufnr)
        require("astronvim.utils.lsp").on_attach(client, bufnr)
        client.resolved_capabilities.document_formatting = false
      end,

      settings = {
        expose_as_code_action = { "all" },
        tsserver_plugins = {
          "@styled/typescript-styled-plugin",
        },
      },
    },
    config = function(_, opts) require("typescript-tools").setup(opts) end,
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
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "stylelint",
        })
      return opts
    end,
  },

  -- None-ls
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require "null-ls"
      return vim.tbl_deep_extend("force", opts, {
        on_attach = require("astronvim.utils.lsp").on_attach,
        sources = require("user.utils").list_insert_unique(opts.sources, {
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.formatting.stylelint,
        }),
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
                enable = false,
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                enable = false,
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
        eslint = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
            "svelte",
            "graphql",
          },
          settings = {
            codeAction = {
              disableRuleComment = { enable = true, location = "separateline" },
              showDocumentation = { enable = true },
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
