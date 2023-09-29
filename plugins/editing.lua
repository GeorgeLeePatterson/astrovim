local ufo_config = require "user.plugins.config.ufo"

return {
  {
    "echasnovski/mini.surround",
    keys = {
      { "Qa", desc = "Add surrounding", mode = { "n", "v" } },
      { "Qd", desc = "Delete surrounding" },
      { "Qf", desc = "Find right surrounding" },
      { "QF", desc = "Find left surrounding" },
      { "Qh", desc = "Highlight surrounding" },
      { "Qr", desc = "Replace surrounding" },
      { "Qn", desc = "Update `MiniSurround.config.n_lines`" },
    },
    opts = { n_lines = 200 },
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
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
  {
    "kevinhwang91/nvim-ufo",
    config = function(_, opts)
      -- global handler
      -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
      -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.
      opts.fold_virt_text_handler = ufo_config.handler
      require("ufo").setup(opts)

      -- buffer scope handler
      -- will override global handler if it is existed
      -- local bufnr = vim.api.nvim_get_current_buf()
    end,
  },
}
