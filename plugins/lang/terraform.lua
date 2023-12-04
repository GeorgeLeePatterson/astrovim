local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local tf_group = ag("terraform_ft", { clear = true })
-- detect terraform
au({ "BufRead", "BufNewFile" }, {
  group = tf_group,
  desc = "Properly set TF filetypes",
  pattern = { "*.tf" },
  callback = function() vim.api.nvim_command "set filetype=terraform" end,
})

-- detect terraform vars
au({ "BufRead", "BufNewFile" }, {
  group = tf_group,
  pattern = { "terraform-vars" },
  desc = "Set tf-vars to hcl",
  callback = function() vim.api.nvim_command "set filetype=hcl" end,
})

-- fix terraform and hcl comment string
au({ "BufRead", "BufNewFile" }, {
  pattern = { "*tf" },
  group = ag("FixTerraformCommentString", { clear = true }),
  desc = "Fix terraform comment string",
  callback = function(ev) vim.bo[ev.buf].commentstring = "# %s" end,
})

return {
  -- [[ LSP ]]
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "terraformls",
        })
      return opts
    end,
  },

  -- [[ Linting / Formatting ]]

  -- Vim-terraform
  {
    "hashivim/vim-terraform",
    cmd = "Terraform",
  },

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
        nls.builtins.formatting.terraform_fmt.with {
          extra_filetypes = { "hcl" },
        },
        nls.builtins.diagnostics.terraform_validate,
      })
      return opts
    end,
  },

  -- [[ Treesitter ]
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "terraform",
          "hcl",
        })
      return opts
    end,
  },
}
