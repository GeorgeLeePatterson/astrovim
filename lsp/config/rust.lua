return {
  config = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = "true",
        },
        checkOnSave = {
          command = "clippy",
        },
        diagnostics = {
          experimental = true,
        },
        hover = {
          actions = {
            references = {
              enable = true,
            },
          },
        },
        lens = {
          references = {
            adt = { enable = true },
            enumVariant = { enable = true },
            method = { enable = true },
            trait = { enable = true },
          },
        },
      },
    },
  },
}
