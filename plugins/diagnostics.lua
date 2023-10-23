local user_config = require "user.config"

return {
  -- [[ Trouble ]]
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>ve",
        function() require("trouble").open "document_diagnostics" end,
        mode = { "n" },
        desc = "Diagnostics (document)",
      },
      {
        "<leader>gR",
        function() require("trouble").open "lsp_references" end,
        mode = { "n" },
        desc = "Diagnostics (document)",
      },
    },
    opts = {
      auto_open = true,
      auto_close = true,
    },
    config = function(_, opts) require("trouble").setup(opts) end,
  },

  -- [[ Lspsaga ]]
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>vci",
        function() vim.cmd [[Lspsaga incoming_calls]] end,
        mode = { "n" },
        desc = "Incoming calls",
      },
      {
        "<leader>vco",
        function() vim.cmd [[Lspsaga outgoing_calls]] end,
        mode = { "n" },
        desc = "Outgoing calls",
      },
      {
        "<leader>vd",
        function() vim.cmd [[Lspsaga peek_definition]] end,
        mode = { "n" },
        desc = "Definition",
      },
    },
    config = function()
      require("lspsaga").setup {
        breadcrumbs = {
          enable = false,
        },
        code_action = {
          extend_gitsigns = true,
        },
        diagnostic = {
          diagnostic_only_current = true,
          extend_relatedInformation = true,
        },
        impelement = { enable = false },
      }
    end,
  },

  -- [[ Actions-preview ]]
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "ga",
        function() require("actions-preview").code_actions() end,
        mode = { "v", "n" },
        { desc = "Actions preview" },
      },
    },
    config = function(_, opts)
      -- Change layout depending on width of window
      -- NOTE: Currently only set at startup, may make autocmd
      local bp = user_config.ui.breakpoint
      local columns = vim.opt.columns:get()
      local ts_theme = require("telescope.themes").get_cursor()
      if columns < bp then ts_theme = require("telescope.themes").get_ivy() end
      opts.telescope = vim.tbl_deep_extend("force", ts_theme, {
        initial_mode = "normal",
        winblend = 5,
      })

      require("actions-preview").setup(opts)
    end,
  },
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    event = "LspAttach",
    keys = {
      {
        "gR",
        function() vim.cmd [[Glance references]] end,
        mode = { "n" },
        desc = "Glance references",
      },
      {
        "gD",
        function() vim.cmd [[Glance definitions]] end,
        mode = { "n" },
        desc = "Glance definitions",
      },
      {
        "gT",
        function() vim.cmd [[Glance type_definitions]] end,
        mode = { "n" },
        desc = "Glance type definitions",
      },
      {
        "gI",
        function() vim.cmd [[Glance implementations]] end,
        mode = { "n" },
        desc = "Glance implementations",
      },
    },
    opts = {
      border = { enable = true },
    },
    config = function(_, opts) require("glance").setup(opts) end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    opts = {
      previewer_cmd = "glow",
      after_open = function(bufnr)
        vim.keymap.set(
          { "n" },
          "<Esc>",
          ":close<CR>",
          { buffer = bufnr, desc = "Close" }
        )
      end,
    },
  },
  {
    -- TODO: Fork this and customize it.
    "AckslD/messages.nvim",
    event = "VeryLazy",
    config = function()
      local buf_name = "messages"
      require("messages").setup {
        buffer_name = buf_name,
        prepare_buffer = function(opts)
          local bufnr = require("user.utils").find_buffer_by_name(buf_name)
          vim.notify("Closing msg buffer: " .. bufnr)
          if bufnr > 0 then vim.api.nvim_buf_delete(bufnr, { force = true }) end
          local buf = vim.api.nvim_create_buf(false, true)
          return vim.api.nvim_open_win(buf, true, opts)
        end,
      }
      -- Create a global helper
      ---@diagnostic disable-next-line: duplicate-set-field
      _G.Msg = function(...) require("messages.api").capture_thing(...) end
    end,
  },
}
