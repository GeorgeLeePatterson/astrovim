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

  -- [[ Linting ]]
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
