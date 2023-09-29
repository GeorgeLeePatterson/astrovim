return {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function(_, opts)
      require("astronvim.utils").set_mappings {
        n = {
          ["<leader>u2"] = { "<cmd>TroubleToggle<CR>", desc = "Toggle Trouble" },
        },
      }
      require("trouble").setup(opts)
    end,
  },
  {
    "aznhe21/actions-preview.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function(_, opts)
      opts.telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.9,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines) return max_lines - 15 end,
        },
      }
      require("actions-preview").setup(opts)
      vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
    end,
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
      after_open = function(bufnr) vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", ":close<CR>", {}) end,
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
      _G.Msg = function(...) require("messages.api").capture_thing(...) end
    end,
  },
}
