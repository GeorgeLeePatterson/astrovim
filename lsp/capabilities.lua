return function(caps)
  local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_ok then
    -- Add additional capabilities supported by nvim-cmp
    caps = cmp_nvim_lsp.default_capabilities(caps)
  end

  -- Enable additional completion for HTML/JSON/CSS
  caps.textDocument.completion.completionItem.snippetSupport = true
  -- Add additional capabilities supported by UFO
  -- M.capabilities.textDocument.foldingRange = {
  --   lineFoldingOnly = true,
  -- }
  return caps
end
