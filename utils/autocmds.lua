-- Setup autocmds to be run on load

-- local astro_utils = require "astronvim.utils"
--
-- local augroup = vim.api.nvim_create_augroup
-- local autocmd = vim.api.nvim_create_autocmd
--
-- local symbols_outline_startup = augroup("symbols_outline_startup", { clear = true })
-- autocmd({ "LspAttach" }, {
--   desc = "Test lush colorscheme changes",
--   group = symbols_outline_startup,
--   callback = function()
--     local ok, _ = pcall(require, "symbols-outline")
--     if ok then vim.cmd [[SymbolsOutline]] end
--   end,
-- })

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local last_status_group = augroup("last_status_group", { clear = true })
autocmd("OptionSet", {
  desc = "Last status changed",
  group = last_status_group,
  callback = function()
    if vim.opt.laststatus:get() ~= 3 then vim.opt.laststatus = 3 end
  end,
})

-- autocmd("BufEnter", {
--     desc = "Open file history for directory on startup with args",
--     group = augroup("file_history_startup", { clear = true }),
--     callback = function()
--       if package.loaded["neo-tree"] then
--         vim.api.nvim_del_augroup_by_name "neotree_start"
--       else
--         local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
--         if stats and stats.type == "directory" then
--           vim.api.nvim_del_augroup_by_name "neotree_start"
--           require "neo-tree"
--         end
--       end
--     end,
--   })
