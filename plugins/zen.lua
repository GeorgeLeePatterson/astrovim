local user_config = require "user.config"
return {
  {
    "folke/zen-mode.nvim",
    dependencies = {
      {
        "folke/twilight.nvim",
        opts = {
          dimming = {
            alpha = 0.4,
          },
        },
      },
    },
    cmd = "ZenMode",
    config = function(_, opts)
      if user_config.defaults.zen then require("zen-mode").toggle(opts) end
    end,
  },
}
