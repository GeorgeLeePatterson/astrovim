return {
  completion = {
    callSnippet = "Both",
    displayContext = 3,
    keywordSnippet = "Both",
    hint = {
      enable = true,
    },
  },
  diagnostics = {
    disable = { "incomplete-signature-doc", "trailing-space" },
    globals = {
      "vim",
      "require",
    },
    unusedLocalExclude = { "_*" },
  },
  doc = {
    privateName = { "^_" },
  },
  telemetry = { enable = false },
}
