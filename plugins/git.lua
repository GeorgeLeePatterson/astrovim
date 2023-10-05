return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    event = "User AstroGitFile",
  },
  {
    "rbong/vim-flog",
    cmd = "Flog",
    dependencies = {
      "tpope/vim-fugitive",
    },
  },
  {
    "NeogitOrg/neogit",
    event = "User AstroGitFile",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
    config = true,
  },
}
