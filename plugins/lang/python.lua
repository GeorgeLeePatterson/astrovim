return {
  -- [[ LSP ]]
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        require("user.utils").list_insert_unique(opts.ensure_installed, {
          "ruff_lsp",
        })
      return opts
    end,
  },

  -- [[ Treesitter ]]
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = require("user.utils").list_insert_unique(
        opts.ensure_installed,
        { "python", "requirements", "toml" }
      )
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
          "ruff",
        })
      return opts
    end,
  },

  -- [[ DAP ]]

  -- {
  -- 	'mfussenegger/nvim-dap',
  -- 	optional = true,
  -- 	dependencies = {
  -- 		'mfussenegger/nvim-dap-python',
  -- 		-- stylua: ignore
  -- 		keys = {
  -- 			{ '<leader>dPt', function() require('dap-python').test_method() end, desc = 'Debug Method' },
  -- 			{ '<leader>dPc', function() require('dap-python').test_class() end, desc = 'Debug Class' },
  -- 		},
  -- 		config = function()
  -- 			local path =
  -- 				require('mason-registry').get_package('debugpy'):get_install_path()
  -- 			require('dap-python').setup(path .. '/venv/bin/python')
  -- 		end,
  -- 	},
  -- },
}
