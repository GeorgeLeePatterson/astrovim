local M = {}

-- Add additional capabilities supported by nvim-cmp
M.capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Enable additional completion for HTML/JSON/CSS
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
-- Add additional capabilities supported by UFO
M.capabilities.textDocument.foldingRange = {
  lineFoldingOnly = true,
}

return M
