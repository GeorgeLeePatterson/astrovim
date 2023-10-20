return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      rainbow = {
        enabled = true,
      },
      modes = {
        treesitter_search = {
          label = { rainbow = { enabled = true } },
        },
      },
    },
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "o", "x" }, desc = "Flash" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "o", "x" }, desc = "Flash Treesitter" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
      { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter Search" },
      { "<c-s>", function() require("flash").toggle() end, mode = { "c" }, desc = "Toggle Flash Search" },
    },
  },
}
