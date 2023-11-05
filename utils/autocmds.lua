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

-- -- Set inlay hints to never be italic, comments to always be
-- vim.cmd [[
-- augroup custom_highlights
--   autocmd!
--   au ColorScheme * :hi LspInlayHint gui=italic cterm=italic
--   au ColorScheme * :hi Comment gui=italic cterm=italic
-- augroup END
-- ]]
