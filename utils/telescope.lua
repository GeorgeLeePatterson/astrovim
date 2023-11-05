local pickers = require "telescope.pickers"
local conf = require("telescope.config").values
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local finders = require "telescope.finders"

local str_contains = require("user.utils").str_contains

local M = {}

local command = vim.cmd

-- fd . -H -d 2 -E "Library/" -E ".Trash/" --base-directory ./ -t d ../../
local default_ignore_dirs = {
  ".Trash",
  "Downloads",
  "Library",
}

local find_bfs = function(prompt, ignore)
  local commands = {
    "bfs",
    "-type",
    "d",
    "-maxdepth",
    "1",
    "-s",
    -- "-unique",
  }

  for _, d in ipairs(ignore) do
    table.insert(commands, "-exclude")
    table.insert(commands, "-name")
    table.insert(commands, d)
  end

  -- Remove leading "./" and trim
  local clean_prompt = prompt:gsub("^%./", ""):gsub("^%s*(.-)", "%1")

  -- Remove directory up, it is a no-op if we're in a directory
  if clean_prompt ~= "../" and clean_prompt:match "%.%./$" then
    clean_prompt = clean_prompt:gsub("%.%./$", "")
  end

  -- Remove consecutive "./" as they just mean "this directory"
  for _ in clean_prompt:gmatch "/%./" do
    clean_prompt = clean_prompt:gsub("[^.]%./", "/")
  end

  local cur_dir = {}

  for _ in clean_prompt:gmatch "%.%./" do
    table.insert(cur_dir, "../")
  end

  local dir = cur_dir[1] and table.concat(cur_dir, "/") or ""

  prompt = clean_prompt:gsub("%.%./", ".*"):gsub("/", ".*")

  if prompt ~= "" and prompt ~= ".*" then
    vim.list_extend(commands, { "-iregex", prompt .. ".*" })
  end

  if dir ~= "" then table.insert(commands, dir) end
  return commands
end

local find_fd = function(prompt, ignore)
  local base_dir = vim.fn.getcwd() or "./"
  local commands = { "fd" }
  if str_contains(prompt, "/") then table.insert(commands, ".") end
  vim.list_extend(commands, {
    "-H",
    "-d",
    "2",
    "-t",
    "d",
    "--base-directory",
    base_dir,
  })
  for _, dir in ipairs(ignore) do
    table.insert(commands, "-E")
    table.insert(commands, dir)
  end
  if prompt and prompt ~= "" then table.insert(commands, prompt) end
  return commands
end

M.telescope_find_dir = function(opts)
  local ignore = (opts or {})["ignore_dirs"] or default_ignore_dirs
  pickers
    .new(opts, {
      prompt_title = "CWD  ",
      finder = finders.new_job(function(prompt)
        if vim.fn.executable "bfs" == 1 then
          return find_bfs(prompt, ignore)
        else
          return find_fd(prompt, ignore)
        end
      end),
      sorter = conf.file_sorter(opts), -- conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if selection ~= nil then
            actions.close(prompt_bufnr)
            vim.notify("Changing directory to " .. selection[1])
            command("cd " .. selection[1])
          end
        end)
        return true
      end,
    })
    :find()
end

M.telescope_search_selection = function()
  local selection = require("user.utils").get_visual_selection()
  if selection and selection ~= "" then
    require("telescope.builtin").grep_string { search = selection }
  else
    require("telescope.builtin").grep_string()
  end
end
return M
