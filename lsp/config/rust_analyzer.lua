return function(opts)
  return vim.tbl_deep_extend("force", opts or {}, {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = "true",
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        checkOnSave = {
          allFeatures = true,
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        completion = {
          fullFunctionSignatures = { enable = true },
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
        inlayHints = {
          bindingModeHints = { enable = true },
          closureCaptureHints = { enable = true },
          discriminantHints = { enable = true },
        },
        lens = {
          references = {
            adt = { enable = true },
            enumVariant = { enable = true },
            method = { enable = true },
            trait = { enable = true },
          },
        },
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
        typing = {
          autoClosingAngleBrackets = { enable = true },
        },
      },
    },
  })
end
