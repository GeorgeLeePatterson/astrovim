local M = {}

function M.buf_is_empty(bufnr)
  bufnr = bufnr or 0
  return vim.api.nvim_buf_line_count(bufnr) == 1
    and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == ""
end

function M.find_buffer_by_name(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if vim.endswith(buf_name, name) then return buf end
  end
  return -1
end

--- Check if a buffer is valid
---@param bufnr number? The buffer to check, default to current buffer
---@return boolean # Whether the buffer is valid or not
function M.is_valid(bufnr)
  if not bufnr then bufnr = 0 end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

function M.is_filebuf(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  return vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
    and name
    and name ~= ""
end

function M.is_no_file(bufnr)
  for _, opt in ipairs { "buftype", "filetype" } do
    if vim.api.nvim_get_option_value(opt, { buf = bufnr }) ~= "" then
      return false
    end
  end
  return M.buf_is_empty(bufnr)
end

function M.list_all_info()
  local wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    table.insert(wins, {
      win_id = win,
      config = vim.api.nvim_win_get_config(win),
      buf = vim.api.nvim_win_get_buf(win),
    })
  end
  ---@diagnostic disable-next-line: undefined_variable
  _G.P(wins)
end

function M.get_file_bufs()
  return vim.tbl_filter(function(buf)
    buf = buf or {}
    return buf["name"] ~= ""
      and vim.api.nvim_buf_get_option(buf["bufnr"] or 0, "buftype") == ""
  end, vim.fn.getbufinfo { buflisted = true }) or {}
end

return M
