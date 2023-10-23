local plugins = {
  -- [[ General ]]
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  -- [[ Linting & Formatting ]]
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>lF",
        function()
          require("conform").format {
            lsp_fallback = true,
            async = false,
          }
        end,
        mode = { "n", "v" },
        desc = "Format document",
      },
    },
    opts = {
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
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
        ["yaml"] = { "prettier" },
        ["markdown"] = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        ["graphql"] = { "prettier" },
        ["handlebars"] = { "prettier" },
        ["python"] = { "isort", "black" },
      },
      formatters = {
        format_on_save = {
          lsp_fallback = true,
          async = false,
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        dprint = {
          condition = function(ctx) return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1] end,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>lc",
        function() require("lint").try_lint() end,
        mode = { "n" },
        desc = "Lint file",
      },
    },
    opts = {
      linters_by_ft = {
        lua = { "selene" },
        markdown = { "markdownlint" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        python = { "pylint" },
      },
    },
    config = function()
      local lint = require "lint"
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function() lint.try_lint() end,
      })
    end,
  },
}

return plugins
