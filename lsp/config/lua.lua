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
    groupSeverity = {
      strong = "Warning",
      strict = "Warning",
    },
    groupFileStatus = {
      ["ambiguity"] = "Opened",
      ["await"] = "Opened",
      ["codestyle"] = "None",
      ["duplicate"] = "Opened",
      ["global"] = "Opened",
      ["luadoc"] = "Opened",
      ["redefined"] = "Opened",
      ["strict"] = "Opened",
      ["strong"] = "Opened",
      ["type-check"] = "Opened",
      ["unbalanced"] = "Opened",
      ["unused"] = "Opened",
    },
    unusedLocalExclude = { "_*" },
  },
  doc = {
    privateName = { "^_" },
  },
  telemetry = { enable = false },
}
