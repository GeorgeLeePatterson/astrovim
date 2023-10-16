return {
  {
    "ray-x/sad.nvim",
    cmd = "Sad",
    dependencies = {
      { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
    },
    keys = {
      {
        "<leader>ss",
        function() vim.cmd(":Sad " .. vim.fn.input "Enter search pattern: ") end,
        mode = { "n", "v", "s" },
        desc = "Sad s&r (cursor)",
      },
    },
    config = function() require("sad").setup {} end,
  },
  {
    "AckslD/muren.nvim",
    cmd = { "MurenOpen", "MurenFresh", "MurenUnique" },
    event = { "BufNewFile", "BufAdd" },
    keys = {
      {
        "<leader>sn",
        function() vim.cmd [[MurenOpen]] end,
        mode = { "n", "v", "s" },
        desc = "Open Muren search",
      },
    },
    config = function()
      require("muren").setup {
        anchor = "bottom_right",
      }
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      {
        "<leader>so",
        function() vim.cmd [[Spectre]] end,
        mode = { "n", "v", "s" },
        desc = "Start spectre search",
      },
    },
    opts = function()
      local prefix = "<leader>s"
      return {
        open_cmd = "new",
        mapping = {
          send_to_qf = { map = prefix .. "q" },
          replace_cmd = { map = prefix .. "c" },
          show_option_menu = { map = prefix .. "o" },
          run_current_replace = { map = prefix .. "C" },
          run_replace = { map = prefix .. "R" },
          change_view_mode = { map = prefix .. "v" },
          resume_last_search = { map = prefix .. "l" },
        },
      }
    end,
  },
}
