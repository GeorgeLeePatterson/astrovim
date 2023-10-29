-- Simple functions to get directories

local M = {}

function M.chdir(dir, _bufnr)
  vim.cmd([[chdir]] .. " " .. dir .. " " .. [[| tcd]] .. " " .. dir)
  local ok, _ = pcall(require("edgy").open, "left")
  if ok then vim.notify("Opened " .. dir) end

  -- local is_alpha = vim.api.nvim_get_option_value(
  --   "filetype",
  --   { scope = "local" }
  -- ) == "alpha"
  -- if is_alpha then
  --   -- local config = require "user.plugins.config.alpha"()
  --   -- require("alpha").start(false, config)
  --   -- vim.cmd [[AlphaRedraw]]
  --   vim.cmd [[Alpha]]
  -- end
end

function M.run_command(cmd, opts)
  opts = opts or {}
  opts["text"] = true
  local output = vim.system(cmd, opts):wait() or {}
  if output and output["code"] == 0 then return output["stdout"] end
end

local z_scores = {}
function M.z_get_scores()
  if z_scores and #z_scores > 0 then return z_scores end
  local results = M.run_command({ "zoxide", "query", "-l", "-s" }, {})

  local count = 1
  for r in results:gmatch "[^\r\n]+" do
    if r and #r > 0 then
      local score = {}
      r = r:gsub("^%s*(.-)%s*$", "%1") or ""
      for part in r:gmatch "%S+" do
        table.insert(score, part)
      end
      local s = tonumber(score[1])
      if s then
        z_scores[count] = { score[1], score[2] }
        count = count + 1
      end
    end
  end
  return z_scores
end

function M.find_files_from_project_git_root()
  local function is_git_repo()
    vim.fn.system "git rev-parse --is-inside-work-tree"
    return vim.v.shell_error == 0
  end
  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end
  local opts = {}
  if is_git_repo() then opts = {
    cwd = get_git_root(),
  } end
  require("telescope.builtin").find_files(opts)
end

function M.live_grep_from_project_git_root()
  local function is_git_repo()
    vim.fn.system "git rev-parse --is-inside-work-tree"

    return vim.v.shell_error == 0
  end

  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end

  local opts = {}

  if is_git_repo() then opts = {
    cwd = get_git_root(),
  } end

  require("telescope.builtin").live_grep(opts)
end

--- A condition function if LSP is attached
---@param bufnr table|integer a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
---@return boolean # whether or not LSP is attached
-- @usage local heirline_component = { provider = "Example Provider", condition = require("astronvim.utils.status").condition.lsp_attached }
function M.lsp_attached(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  return next(vim.lsp.get_clients { bufnr = bufnr or 0 }) ~= nil
end

function M.toggle_lsp(bufnr)
  if bufnr == nil then bufnr = vim.api.nvim_get_current_buf() end
  if bufnr and type(bufnr) ~= "table" then bufnr = { bufnr = bufnr } end
  local clients = vim.lsp.get_clients(bufnr)
  if not vim.tbl_isempty(clients) then
    vim.cmd "LspStop"
  else
    vim.cmd "LspStart"
  end
end

function M.start_lsp(bufnr, lsp_name)
  if bufnr and type(bufnr) ~= "table" then bufnr = { bufnr = bufnr } end
  local clients = vim.lsp.get_clients(bufnr)

  if vim.tbl_isempty(clients) then
    lsp_name = lsp_name or ""
    vim.cmd("LspStart " .. lsp_name)
  end
end

return M
