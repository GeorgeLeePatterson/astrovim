local user_config = require "user.config"
local favorite = user_config.get_config "mappings.favorite"
  or function(name) return name end

return {
  -- [[ Editing ]]

  -- Undotree
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      {
        "<leader>U",
        "<cmd>lua require('undotree').toggle()<cr>",
        desc = "[U]ndo tree",
      },
    },
    opts = {
      float_diff = true, -- using float window previews diff, set this `true` will disable layout option
      layout = "left_bottom", -- "left_bottom", "left_left_bottom"
      ignore_filetype = {
        "Undotree",
        "UndotreeDiff",
        "qf",
        "TelescopePrompt",
        "spectre_panel",
        "tsplayground",
      },
      window = {
        winblend = 30,
      },
      keymaps = {
        ["j"] = "move_next",
        ["k"] = "move_prev",
        ["J"] = "move_change_next",
        ["K"] = "move_change_prev",
        ["<cr>"] = "action_enter",
        ["p"] = "enter_diffbuf",
        ["q"] = "quit",
      },
    },
  },

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
        desc = "Troubl[e] document",
      },
      {
        "<leader>gR",
        function() require("trouble").open "lsp_references" end,
        mode = { "n" },
        desc = "Trouble [R]eferences",
      },
    },
    opts = {
      auto_open = true,
      auto_close = true,
      include_declaration = {
        "lsp_references",
        "lsp_implementations",
        "lsp_definitions",
        "document_diagnostics",
      }, -- for the given modes, include the declaration of the current symbol in the results
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
        "<leader>La",
        function() vim.cmd [[Lspsaga code_action]] end,
        mode = { "n" },
        desc = favorite "code [a]ctions",
      },
      {
        "<leader>Li",
        function() vim.cmd [[Lspsaga incoming_calls]] end,
        mode = { "n" },
        desc = favorite "[c]alls [i]ncoming",
      },
      {
        "<leader>Lf",
        function() vim.cmd [[Lspsaga finder def+ref+imp]] end,
        mode = { "n" },
        desc = favorite "[f]ind def, ref, & impl",
        -- FYI (keymaps)
        -- shuttle = '[w' shuttle bettween the finder layout window
        -- toggle_or_open = 'o' toggle expand or open
        -- vsplit = 's' open in vsplit
        -- split = 'i' open in split
        -- tab = 't' open in tab
        -- tabnew = 'r' open in new tab
        -- quit = 'q' quit the finder, only works in layout left window
        -- close = '<C-c>k' close finder
      },
      {
        "<leader>Lo",
        function() vim.cmd [[Lspsaga outgoing_calls]] end,
        mode = { "n" },
        desc = favorite "[c]alls [o]utgoing",
      },
      {
        "<leader>Ld",
        function() vim.cmd [[Lspsaga peek_definition]] end,
        mode = { "n" },
        desc = "[d]efinition",
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
        desc = favorite "Preview [a]ctions",
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
        desc = favorite "Glance references",
      },
      {
        "gD",
        function() vim.cmd [[Glance definitions]] end,
        mode = { "n" },
        desc = favorite "Glance definitions",
      },
      {
        "gT",
        function() vim.cmd [[Glance type_definitions]] end,
        mode = { "n" },
        desc = favorite "Glance type definitions",
      },
      {
        "gI",
        function() vim.cmd [[Glance implementations]] end,
        mode = { "n" },
        desc = favorite "Glance implementations",
      },
    },
    opts = {
      border = { enable = true },
      -- mappings = {
      --     list = {
      --       ['j'] = actions.next, -- Bring the cursor to the next item in the list
      --       ['k'] = actions.previous, -- Bring the cursor to the previous item in the list
      --       ['<Down>'] = actions.next,
      --       ['<Up>'] = actions.previous,
      --       ['<Tab>'] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
      --       ['<S-Tab>'] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
      --       ['<C-u>'] = actions.preview_scroll_win(5),
      --       ['<C-d>'] = actions.preview_scroll_win(-5),
      --       ['v'] = actions.jump_vsplit,
      --       ['s'] = actions.jump_split,
      --       ['t'] = actions.jump_tab,
      --       ['<CR>'] = actions.jump,
      --       ['o'] = actions.jump,
      --       ['l'] = actions.open_fold,
      --       ['h'] = actions.close_fold,
      --       ['<leader>l'] = actions.enter_win('preview'), -- Focus preview window
      --       ['q'] = actions.close,
      --       ['Q'] = actions.close,
      --       ['<Esc>'] = actions.close,
      --       ['<C-q>'] = actions.quickfix,
      --       -- ['<Esc>'] = false -- disable a mapping
      --     },
      --     preview = {
      --       ['Q'] = actions.close,
      --       ['<Tab>'] = actions.next_location,
      --       ['<S-Tab>'] = actions.previous_location,
      --       ['<leader>l'] = actions.enter_win('list'), -- Focus list window
      --     },
      --   },
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
