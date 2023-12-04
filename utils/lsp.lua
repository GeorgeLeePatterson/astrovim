local M = {}

local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

function M.capabilities(capabilities)
  capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()

  local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_ok then
    -- Add additional capabilities supported by nvim-cmp
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local ufo_present, _ = pcall(require, "ufo")
  if ufo_present then
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
  end
  return capabilities
end

---@param on_attach fun(client:lsp.Client, buffer:integer)
function M.lsp_on_attach(on_attach)
  local lsp_attach_au = ag("CustomLspAttach", { clear = true })
  au("LspAttach", {
    group = lsp_attach_au,
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client ~= nil then on_attach(client, buffer) end
    end,
  })
end

return M
