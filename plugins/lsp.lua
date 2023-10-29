local user_config = require "user.config"

-- Simple helper function to load a language plugin
local load_language = function(lang)
  local ok, l = pcall(require, "user.plugins.lang." .. lang)
  if ok then
    return l
  else
    return {}
  end
end

local languages = vim.tbl_map(
  function(lang) return load_language(lang) or {} end,
  user_config.languages
)

-- Load core LSP plugins first

local plugins = {
  -- [[ LSP ]]

  -- Mason-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "ansiblels",
          "yamlls",
        })
    end,
  },

  -- Mason-nvim-dap
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "bash",
          "js",
          "python",
        })
      return opts
    end,
  },

  -- [[ Formatters / Linters]]

  -- Mason-null-ls
  { "jay-babu/mason-null-ls.nvim" },
  {
    -- Deprecated, use nvimtools/none-ls.nvim instead
    "jose-elias-alvarez/null-ls.nvim",
    enabled = false,
    cond = function() return false end,
  },

  -- None-ls
  {
    -- Community maintained alternative
    "nvimtools/none-ls.nvim",
    main = "null-ls",
    event = "User AstroFile",
    dependencies = {
      {
        "jay-babu/mason-null-ls.nvim",
        cmd = { "NullLsInstall", "NullLsUninstall" },
      },
    },
    opts = function(_, opts)
      local null_ls = require "null-ls"
      return vim.tbl_deep_extend("force", opts, {
        on_attach = require("astronvim.utils.lsp").on_attach,
        sources = require("user.utils").list_insert_unique(opts.sources, {
          null_ls.builtins.formatting.just,
          null_ls.builtins.formatting.shfmt,
        }),
        -- should_attach = function(bufnr)
        --   local large_buf = vim.b[bufnr].large_buf
        --   if large_buf then
        --     vim.notify "Disabling none-ls"
        --     return false
        --   else
        --     return true
        --   end
        -- end,
      })
    end,
  },

  -- Conform
  {
    "stevearc/conform.nvim",
    event = { "VeryLazy" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lF",
        function()
          require("conform").format {
            lsp_fallback = true,
            async = true,
          }
        end,
        mode = { "n", "v" },
        desc = "Format document",
      },
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        formatters_by_ft = {
          ["json"] = { "prettier" },
          ["jsonc"] = { "prettier" },
          ["yaml"] = { "prettier" },
          ["handlebars"] = { "prettier" },
          ["justfile"] = { "just" },
        },
        format_on_save = {
          lsp_fallback = true,
          async = true,
        },
        formatters = {
          shfmt = { prepend_args = { "-i", "2" } },
        },
      })
    end,
    config = function(_, opts) require("conform").setup(opts) end,
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  },

  -- Nvim-lint
  {
    "mfussenegger/nvim-lint",
    event = "User AstroFile",
    keys = {
      {
        "<leader>lc",
        function() require("lint").try_lint() end,
        mode = { "n" },
        desc = "Lint file",
      },
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        linters_by_ft = {
          ["json"] = { "jsonlint" },
        },
      })
    end,
    config = function()
      local lint = require "lint"
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWritePost", "InsertLeave" },
        {
          group = lint_augroup,
          callback = function(args)
            local large_file = (vim.b[args.buf] or {}).large_buf
            if large_file ~= nil and large_file then return end
            lint.try_lint()
          end,
        }
      )
    end,
  },
}

-- Then load langage specific plugins
for _, lang in ipairs(languages) do
  table.insert(plugins, lang)
end

return plugins
