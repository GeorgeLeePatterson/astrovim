return {
  { "AstroNvim/astrotheme", enabled = false },
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "ansiblels",
        "cssls",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "pyright",
        "rust_analyzer",
        "taplo",
        "tsserver",
        "yamlls",
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "prettier",
        "stylua",
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
        "bash",
        "js",
        "python",
        "codelldb",
      })
    end,
  },
  {
    -- Deprecated, use nvimtools/none-ls.nvim instead
    "jose-elias-alvarez/null-ls.nvim",
    enabled = false,
  },
  {
    "nvimtools/none-ls.nvim",
    name = "null-ls",
    dependencies = {
      {
        "jay-babu/mason-null-ls.nvim",
        cmd = { "NullLsInstall", "NullLsUninstall" },
        opts = { handlers = {} },
      },
    },
    event = "User AstroFile",
    opts = function() return { on_attach = require("astronvim.utils.lsp").on_attach } end,
  },
  -- {
  --   "mrjones2014/legendary.nvim",
  --   priority = 10000,
  --   -- lazy = false,
  --   opts = {
  --     select_prompt = "  ~ legendary ~  ",
  --     lazy_nvim = { auto_register = true },
  --     which_key = { auto_register = true },
  --   },
  -- },
  {
    "mrjones2014/smart-splits.nvim",
    opts = {
      ignored_filetypes = {
        "nofile",
        "quickfix",
        "qf",
        "prompt",
      },
      ignored_buftypes = {
        "nofile",
        "neo-tree",
      },
      multiplexer_integration = "wezterm",
    },
  },
}
