return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      rainbow = {
        enabled = true,
      },
    },
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "rainbowhxch/accelerated-jk.nvim",
    lazy = false,
    keys = {
      { "j", mode = { "n" }, "<Plug>(accelerated_jk_gj)", desc = "Accelerated j" },
      { "k", mode = { "n" }, "<Plug>(accelerated_jk_gk)", desc = "Accelerated k" },
    },
  },
  {
    "roobert/tabtree.nvim",
    event = "VeryLazy",
    config = function() require("tabtree").setup() end,
  },
}
