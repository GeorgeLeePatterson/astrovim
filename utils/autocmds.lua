local M = {}

local get_config = require("user.config").get_config

local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

-- [[ Buffers ]]

local function toggle_buf_large(bufnr, is_large)
  bufnr = bufnr or 0
  local ibl_ok, ibl = pcall(require, "ibl")
  if is_large and ibl_ok then
    vim.notify "Disabling global features for large file"
    ibl.setup_buffer(bufnr, { enabled = false })
  end
end

local buf_large = ag("buf_large", { clear = true })
au({ "BufRead" }, {
  group = buf_large,
  pattern = "*",
  desc = "Turn off large buffer local settings",
  callback = function(args)
    local ok, stats = pcall(
      vim.loop.fs_stat,
      vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    )
    local large = (
      ok
      and stats
      and stats.size > (vim.g.max_file.size or (1024 * 1024))
    )

    if large then
      vim.notify "Disabling local features for large file"
      vim.cmd "syntax clear"
      vim.cmd "setlocal nornu"
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.spell = false
    end
    toggle_buf_large(args.buf, large)
  end,
})

au({ "BufEnter" }, {
  group = buf_large,
  pattern = "*",
  desc = "Toggle large buffer global settings",
  callback = function(args)
    local ok, stats = pcall(
      vim.loop.fs_stat,
      vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    )
    local large = (
      ok
      and stats
      and stats.size > (vim.g.max_file.size or (1024 * 1024))
    )
    toggle_buf_large(args.buf, large)
  end,
})

-- [[ Colorscheme ]]
local search_hl = get_config "defaults.search_hl"
local colorscheme_au_group = ag("colorscheme_au_group", { clear = true })

if search_hl then
  au({ "Colorscheme" }, {
    desc = "Updates search and incsearch hi on colorscheme",
    group = colorscheme_au_group,
    callback = function()
      local utils = require "user.utils"

      utils.mod_hl("Search", search_hl, true)
      utils.mod_hl("IncSearch", search_hl, true)
    end,
  })
end

-- [[ Plugins ]]

-- Rainbow-delimiters
local rb_au_group = ag("rb_au_group", { clear = true })
au({ "LspAttach" }, {
  group = rb_au_group,
  pattern = "*",
  desc = "Refresh rainbow delimiters when lsp attaches",
  callback = function(args)
    local ok, rb = pcall(require, "rainbow-delimiters")
    if ok then pcall(function() rb.enable(args.buf) end) end
  end,
})

-- Telescope
local telescope_au = ag("telescope_au", { clear = true })
-- vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"
au({ "User" }, {
  group = telescope_au,
  pattern = "TelescopePreviewerLoaded",
  desc = "Set telescope preview to use line numbers",
  callback = function() vim.opt_local.number = true end,
})

-- Edgy
-- Attempt to fix tabclose bug
local edgy_au = ag("edgy_au", { clear = true })
au({ "TabLeave" }, {
  group = edgy_au,
  pattern = "*",
  desc = "Close edgy when tabcloses (bugfix)",
  callback = function()
    local ok, edgy = pcall(require, "edgy")
    if ok then
      if pcall(function() edgy.close() end) then
        pcall(function() edgy.close() end)
      end
    end
  end,
})

-- Alpha

-- when there is no buffer left show Alpha dashboard
-- requires "famiu/bufdelete.nvim" and "goolord/alpha-nvim"
local alpha_on_empty = ag("alpha_on_empty", { clear = true })
au("User", {
  pattern = "BDeletePost*",
  group = alpha_on_empty,
  callback = function(event)
    local fallback_name = vim.api.nvim_buf_get_name(event.buf)
    local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
    local fallback_on_empty = fallback_name == "" and fallback_ft == ""

    if fallback_on_empty then
      -- require("neo-tree").close_all()
      vim.api.nvim_command "Alpha"
      vim.api.nvim_command(event.buf .. "bwipeout")
    end
  end,
})

-- [[ Options ]]

-- Some autocmds or plugins may modify this. I don't want it modified.
local last_status_group = ag("last_status_group", { clear = true })
au("OptionSet", {
  desc = "Last status changed",
  group = last_status_group,
  callback = function()
    if vim.opt.laststatus:get() ~= 3 then vim.opt.laststatus = 3 end
  end,
})

-- Create autocommand to bind keymaps
--
-- @param group
-- @param event
-- @param pattern
-- @param keymap_opts - list of keymap options { mode, lhs, rhs, opts }
M.create_buffer_keymap = function(group, event, pattern, keymap_opts)
  if not keymap_opts or type(keymap_opts) ~= "table" or #keymap_opts == 0 then
    return
  end

  local keymap = vim.keymap.set
  au(event, {
    group = ag(group, { clear = true }),
    pattern = pattern,
    callback = function(args)
      vim.tbl_map(function(k)
        local opts = k.opts or {}
        opts["buffer"] = args.buf
        keymap(k.mode, k.lhs, k.rhs, opts)
      end, keymap_opts)
    end,
  })
end

-- -- Set inlay hints to never be italic, comments to always be
-- vim.cmd [[
-- augroup custom_highlights
--   autocmd!
--   au ColorScheme * :hi LspInlayHint gui=italic cterm=italic
--   au ColorScheme * :hi Comment gui=italic cterm=italic
-- augroup END
-- ]]

return M
