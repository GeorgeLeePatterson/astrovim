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
          context = 16,
        },
      },
    },
    cmd = "ZenMode",
    config = function(_, opts)
      opts.window = { width = 0.8 }
      local zen = require "zen-mode"
      zen.setup(opts)
      if user_config.defaults.zen then zen.toggle(opts) end
    end,
  },
}
