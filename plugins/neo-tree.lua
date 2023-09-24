return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    {
      -- only needed if you want to use the commands with "_with_window_picker" suffix
      "s1n7ax/nvim-window-picker",
      event = "VeryLazy",
      opts = {
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
        other_win_hl_color = "#e35e4f",
      },
    },
  },
  opts = {
    open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        always_show = { ".github", ".gitignore" },
        hide_gitignored = false,
      },
    },
  },
}
