-- Add any on_attach keymaps or whatever to LSPs.

return function()
  -- -- Attach nvim-navic if installed
  -- if a_utils.is_available "nvim-navic" then
  --   if client.server_capabilities.documentSymbolProvider then
  --     local nvim_navic_avail, nvim_navic = pcall(require, "nvim_navic")
  --     if nvim_navic_avail then nvim_navic.attach(client, bufnr) end
  --   end
  -- end
end
