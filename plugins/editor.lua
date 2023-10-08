local ufo_config = require "user.plugins.config.ufo"

return {
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "markdown",
    config = true,
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
      opts.fold_virt_text_handler = ufo_config.handler
      require("ufo").setup(opts)
    end,
  },
}
