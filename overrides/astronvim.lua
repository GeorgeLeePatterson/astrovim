local is_available = require("astronvim.utils").is_available
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Override resession autocmds to use tab scoped buffer
if is_available "resession.nvim" then
  autocmd("VimLeavePre", {
    desc = "Save session on close",
    group = augroup("resession_auto_save", { clear = true }),
    callback = function()
      local buf_utils = require "astronvim.utils.buffer"
      local autosave = buf_utils.sessions.autosave
      if autosave and buf_utils.is_valid_session() then
        local save = require("resession").save_tab
        if autosave.last then save("Last Session", { notify = false }) end
        if autosave.cwd then save(vim.fn.getcwd(), { dir = "dirsession", notify = false }) end
      end
    end,
  })
end
