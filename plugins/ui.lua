return {
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
      -- {
      --   "<C-f>",
      --   function()
      --     if not require("noice.lsp").scroll(4) then return "<C-f>" end
      --   end,
      --   mode = { "n", "i", "s" },
      --   desc = "Lsp scroll down",
      --   { silent = true, expr = true, noremap = true },
      -- },
      -- {
      --   "<C-b>",
      --   function()
      --     if not require("noice.lsp").scroll(-4) then return "<C-b>" end
      --   end,
      --   mode = { "n", "i", "s" },
      --   desc = "Lsp scroll up",
      --   { silent = true, expr = true, noremap = true },
      -- },
      { "<leader>vC", function() require("notify").dismiss {} end, mode = { "n" }, desc = "Clear all notifications" },
    },
    event = "VeryLazy",
    config = require("user.plugins.config.noice").config,
  },
  {
    "stevearc/dressing.nvim",
    lazy = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      input = { enabled = false },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function(_, opts)
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup(vim.tbl_deep_extend("force", opts, { scope = { highlight = highlight } }))

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
