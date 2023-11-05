return function(_, opts)
  local fzf_lua_status_ok, fzf_lua = pcall(require, "fzf-lua")
  if not fzf_lua_status_ok then return end
  fzf_lua.setup(vim.tbl_deep_extend("force", {
    "telescope",
    --[[ fzf_colors = {
      ["fg"]          = { "fg", "CursorLine" },
      ["bg"]          = { "bg", "Normal" },
      ["hl"]          = { "fg", "Comment" },
      ["fg+"]         = { "fg", "Normal" },
      ["bg+"]         = { "bg", "CursorLine" },
      ["hl+"]         = { "fg", "Statement" },
      ["info"]        = { "fg", "PreProc" },
      ["prompt"]      = { "fg", "Conditional" },
      ["pointer"]     = { "fg", "Exception" },
      ["marker"]      = { "fg", "Keyword" },
      ["spinner"]     = { "fg", "Label" },
      ["header"]      = { "fg", "Comment" },
      ["gutter"]      = { "bg", "Normal" },
  }, ]]
    keymap = {
      builtin = {
        ["<C-l>"] = "toggle-preview",
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
      },
    },
    winopts_fn = function()
      return {
        title = "FZF LUA",
        title_pos = "center",
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
        preview = {
          flip_columns = 200,
        },
      }
    end,
    fzf_opts = {
      -- options are sent as `<left>=<right>`
      -- set to `false` to remove a flag
      -- set to '' for a non-value flag
      -- for raw args use `fzf_args` instead
      ["--ansi"] = "",
      ["--info"] = "inline",
      ["--height"] = "100%",
      ["--layout"] = "reverse",
      ["--border"] = "none",
    },
  }, opts or {}))

  -- vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "Comment", default = true })
end

-- Example to create directory switcher. Adapt to `cd` command

-- _G.fzf_dirs = function(opts)
--   local fzf_lua = require'fzf-lua'
--   opts = opts or {}
--   opts.prompt = "Directories> "
--   opts.fn_transform = function(x)
--     return fzf_lua.utils.ansi_codes.magenta(x)
--   end
--   opts.actions = {
--     ['default'] = function(selected)
--       vim.cmd("cd " .. selected[1])
--     end
--   }
--   fzf_lua.fzf_exec("fd --type d", opts)
-- end
--
-- -- map our provider to a user command ':Directories'
-- vim.cmd([[command! -nargs=* Directories lua _G.fzf_dirs()]])
--
-- -- or to a keybind, both below are (sort of) equal
-- vim.keymap.set('n', '<C-k>', _G.fzf_dirs)
-- vim.keymap.set('n', '<C-k>', '<cmd>lua _G.fzf_dirs()<CR>')
--
-- -- We can also send call options directly
-- :lua _G.fzf_dirs({ cwd = <other directory> })
