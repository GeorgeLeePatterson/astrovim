local is_available = require("astronvim.utils").is_available
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- -- Override resession autocmds to use tab scoped buffer
-- -- Uncomment if using resession, highly recommended
-- if is_available "resession.nvim" then
--   autocmd("VimLeavePre", {
--     desc = "Save session on close",
--     group = augroup("resession_auto_save", { clear = true }),
--     callback = function()
--       local buf_utils = require "astronvim.utils.buffer"
--       local autosave = buf_utils.sessions.autosave
--       if autosave and buf_utils.is_valid_session() then
--         local save = require("resession").save_tab
--         if autosave.last then save("Last Session", { notify = false }) end
--         if autosave.cwd then save(vim.fn.getcwd(), { dir = "dirsession", notify = false }) end
--       end
--     end,
--   })
-- end

-- Neo tree with edgy
if is_available "neo-tree.nvim" then
  autocmd("BufEnter", {
    desc = "Open Neo-Tree on startup with directory",
    group = augroup("neotree_start", { clear = true }),
    callback = function()
      if package.loaded["neo-tree"] then
        vim.api.nvim_del_augroup_by_name "neotree_start"
      else
        local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
        if stats and stats.type == "directory" then
          vim.api.nvim_del_augroup_by_name "neotree_start"
          local ok, edgy = pcall(require, "folke/edgy.nvim")
          if ok then
            edgy.setup(require "user.plugins.config.edgy")
          else
            vim.notify "Could not start edgy"
          end
        end
      end
    end,
  })
end

-- Disable autocmd for alpha. No statusline would be ideal, but it's buggy
pcall(vim.api.nvim_del_augroup_by_name, "alpha_settings")

if is_available "alpha-nvim" then
  autocmd("VimEnter", {
    desc = "Start Alpha when vim is opened with no arguments",
    group = augroup("alpha_autostart", { clear = true }),
    callback = function()
      local should_skip
      local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
      if
        #lines > 1 -- don't open if current buffer has more than 1 line
        or (#lines == 1 and lines[1]:len() > 0) -- don't open the current buffer if it has anything on the first line
        or #vim.tbl_filter(function(bufnr) return vim.bo[bufnr].buflisted end, vim.api.nvim_list_bufs()) > 1 -- don't open if any listed buffers
        or not vim.o.modifiable -- don't open if not modifiable
      then
        should_skip = true
      else
        for _, arg in pairs(vim.v.argv) do
          if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
            should_skip = true
            break
          end
        end
      end
      if should_skip then return end
      require("alpha").start(true, require("alpha").default_config)
      vim.schedule(function() vim.cmd.doautocmd "FileType" end)
    end,
  })
end

-- Disable Astronvim neo-tree startup
pcall(vim.api.nvim_del_augroup_by_name, "neotree_start")
