-- Setup autocmds to be run on load

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Some autocmds or plugins may modify this. I don't want it modified.
local last_status_group = augroup("last_status_group", { clear = true })
autocmd("OptionSet", {
  desc = "Last status changed",
  group = last_status_group,
  callback = function()
    if vim.opt.laststatus:get() ~= 3 then vim.opt.laststatus = 3 end
  end,
})
