-- local load_capabilities = function()
--   local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
--   if ok then cmp_lsp.default_capabilities() end
-- end
local has_selene =
  vim.list_contains(require("user.config").get_config "linters.lua", "selene")

return function(opts)
  return vim.tbl_extend("force", opts or {}, {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Both",
          displayContext = 3,
          keywordSnippet = "Both",
          hint = {
            enable = true,
          },
        },
        diagnostics = {
          enable = not has_selene,
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
      },
    },
  })
end
