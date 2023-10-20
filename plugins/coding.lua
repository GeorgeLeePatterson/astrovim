return {
  -- [[ General ]]
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },
  -- [[ Typescript ]]
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function(_, opts)
      require("typescript-tools").setup(vim.tbl_deep_extend("force", opts, {
        settings = {
          tsserver_plugins = {
            "@styled/typescript-styled-plugin",
          },
        },
      }))
    end,
  },

  -- [[ Linting & Formatting ]]
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        ["javascript"] = { "dprint" },
        ["javascriptreact"] = { "dprint" },
        ["typescript"] = { "dprint" },
        ["typescriptreact"] = { "dprint" },
      },
      formatters = {
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
    opts = {
      linters_by_ft = {
        lua = { "selene", "luacheck" },
        markdown = { "markdownlint" },
      },
    },
  },
}
