return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "rrethy/nvim-treesitter-textsubjects",
  },
  opts = function(_, opts)
    opts.auto_install = true
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
      "lua",
      "bash",
      "css",
      "html",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "rust",
      "toml",
      "vim",
    })

    opts.textsubjects = {
      enable = true,
      -- prev_selection = ",",
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
        ["i;"] = "textsubjects-container-inner",
      },
    }
    return opts
  end,
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      return require("astronvim.utils").extend_tbl(opts, {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      })
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = { useDefaultKeymapps = true },
  },
}
