return {
  {
    "simrat39/rust-tools.nvim",
    opts = function()
      local server = require("astronvim.utils.lsp").config "rust_analyzer"
      server.settings["rust-analyzer"] = {
        standalone = true,
        checkOnSave = {
          command = "",
        },
      }
      return { server = server }
    end,
  },
}
