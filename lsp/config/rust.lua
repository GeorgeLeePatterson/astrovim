return {
  keys = {
    { "K", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
    -- { "<leader>cR", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
    { "<leader>dr", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
  },
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

      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"] = { "async_trait" },
          ["napi-derive"] = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
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
}
