-- This plugin is confusing. I wished it worked better. Will probably remove

local group = vim.api.nvim_create_augroup("LuadevMappings", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
  pattern = "*",
  desc = "Luadev key mappings",
  group = group,
  callback = function(ev)
    if vim.endswith(ev.file, "[nvim-lua]") then
      local wk = require "which-key"
      wk.register({
        ["<leader>ll"] = { "\\<Plug>(Luadev-RunLine)<CR>", desc = "Run luadev for line" },
      }, {
        mode = "n",
        buffer = ev.buf,
        noremap = true,
      })
    end
  end,
})

return {
  {
    "bfredl/nvim-luadev",
    cmd = "Luadev",
  },
}
