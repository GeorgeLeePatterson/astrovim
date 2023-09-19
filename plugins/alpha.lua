return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function(_plugin, _opts)
    local alpha = require "alpha"
    local theme = require "alpha.themes.theta"
    local config = theme.config
    local dashboard = require "alpha.themes.dashboard"
    local buttons = {

      type = "group",
      val = {
        { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("e", "  New file", "<cmd>ene<CR>"),
        dashboard.button("SPC f", "󰍉  Find file"),
        dashboard.button("SPC F", "󰈞  Find text"),
        dashboard.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
        dashboard.button("q", "󰩈  Quit", "<cmd>qa<CR>"),
      },
      position = "center",
    }
    config.layout[6] = buttons
    alpha.setup(config)
  end,
}
