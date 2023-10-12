---@diagnostic disable: missing-fields
return {
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
