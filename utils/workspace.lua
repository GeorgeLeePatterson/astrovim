-- Simple functions to get directories

local M = {}

function M.run_command(cmd, opts)
  opts = opts or {}
  table.insert(opts, { text = true })
  local output = vim.system(cmd, opts):wait() or {}
  if output and output["code"] == 0 then return output["stdout"] end
end

local z_scores = {}
function M.z_get_scores()
  if z_scores and #z_scores > 0 then return z_scores end
  local results = M.run_command { "zoxide", "query", "-l", "-s" }

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

return M
