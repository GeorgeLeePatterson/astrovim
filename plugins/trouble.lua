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
}
