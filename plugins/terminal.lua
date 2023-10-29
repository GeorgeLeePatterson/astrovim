---@diagnostic disable: missing-fields
return {
  -- Smart-splits
  -- This is integrated with wezterm. See `~/.config/wezterm/keys.lua` for mappings
  {
    "mrjones2014/smart-splits.nvim",
    enabled = not vim.g.neovide,
    opts = {
      ignored_filetypes = {
        "nofile",
        "quickfix",
        "qf",
        "prompt",
        "neo-tree",
      },
      ignored_buftypes = {},
      multiplexer_integration = "wezterm",
    },
  },

  -- Wezterm
  "willothy/wezterm.nvim",
  cmd = "WeztermSpawn",
  event = "VeryLazy",
  keys = {
    {
      "<leader>Wt",
      ":WeztermSpawn<CR>",
      mode = { "n" },
      desc = "New wezterm tab",
    },
    {
      "<leader>Wp",
      function()
        require("wezterm").split_pane.vertical {
          percent = 20,
        }
      end,
      mode = { "n" },
      desc = "New vertical pane",
    },
    {
      "<leader>WP",
      function()
        require("wezterm").split_pane.horizontal {
          percent = 33,
        }
      end,
      mode = { "n" },
      desc = "New horizontal pane",
    },
  },
  config = true,
}
