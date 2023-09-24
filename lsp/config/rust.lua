local user_utils = require "user.utils"

local rust_analyzer = {
  config = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = "true",
        },
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
  setup_handlers = function(_, opts)
    opts.on_attach = function(client, bufnr)
      opts.on_attach(client, bufnr)
      user_utils.lsp_on_attach(client, bufnr)
    end
    require("rust-tools").setup {
      server = opts,
    }
  end,
}
return rust_analyzer
