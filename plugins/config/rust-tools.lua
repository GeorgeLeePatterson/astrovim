local lsp_config = require "user.plugins.config.lsp"

local M = {}

M.setup = function(_, o)
  require("rust-tools").setup {
    server = {
      on_attach = function(client, bufnr)
        pcall(require("astronvim.utils.lsp").on_attach, client, bufnr)
        pcall(o.on_attach, client, bufnr)
        local rt_ok, rt = pcall(require, "rust-tools")
        if rt_ok then
          vim.keymap.set(
            "n",
            "<C-space>",
            rt.hover_actions.hover_actions,
            { buffer = bufnr, desc = "🦀 Rust hover actions" }
          )
          vim.keymap.set(
            "n",
            "<leader>a",
            rt.code_action_group.code_action_group,
            { buffer = bufnr, desc = "🦀 Rust code actions" }
          )
        end
      end,
      capabilities = lsp_config.capabilities,
    },
  }
  -- Add cargo autocmp
  local ok, cmp = pcall(require, "cmp")
  if ok then
    vim.api.nvim_create_autocmd("BufRead", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
      pattern = "Cargo.toml",
      ---@diagnostic disable-next-line: missing-fields
      callback = function() cmp.setup.buffer { sources = { { name = "crates" } } } end,
    })
  end
end

return M
