local pickers = require "telescope.pickers"
local conf = require("telescope.config").values
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local finders = require "telescope.finders"

local M = {}

local command = vim.cmd

-- fd . -H -d 2 -E "Library/" -E ".Trash/" --base-directory ./ -t d ../../
local default_ignore_dirs = {
  ".Trash",
  "Downloads",
  "Library",
}

M.telescope_find_dir = function(opts)
  local ignore = (opts or {})["ignore_dirs"] or default_ignore_dirs
  local str_contains = require("user.utils").str_contains
  pickers
    .new(opts, {
      prompt_title = "CWD  ",
      finder = finders.new_job(function(prompt)
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
        -- commands = table.concat(commands, " ")
        vim.notify("Running command" .. vim.inspect { commands })
        return commands
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
