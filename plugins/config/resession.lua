local M = {}

--
-- Resession helpers
--
function M.session_name_to_path(name) return string.gsub(name, "_", "/") end

function M.open_from_dashboard(session, dir, bufnr, group)
  local found_group = nil
  -- Get alpha autocommands, delete if any
  local ok, autocommands = pcall(vim.api.nvim_get_autocmds, { group = group })
  if ok then
    for _, cmd in ipairs(autocommands) do
      if not pcall(function() vim.api.nvim_del_augroup_by_id(cmd.group) end) then found_group = cmd.group end
    end
  end
  -- Load resession
  if not pcall(function() require("resession").load(session, { dir = dir, reset = true }) end) then
    vim.notify("Could not load session", vim.log.levels.ERROR)
  end
  -- Close alpha, ignore errors
  pcall(function() require("alpha").close { buf = bufnr, group = found_group } end)

  -- Try to close tab if possible
  -- TODO
end

return M
