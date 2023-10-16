local opt = vim.opt

local formatoptions = function(o)
  o.formatoptions = o.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- I'm not in gradeschool anymore
end

-- Persistent formatoptions
local format_group = vim.api.nvim_create_augroup("FormatOptions", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  desc = "Always set formatoptions consistently",
  group = format_group,
  callback = function() formatoptions(vim.opt_local) end,
})

-- Cursorline highlighting control
--  Only have it on in the active buffer
opt.cursorline = true -- Highlight the current line
local cursorline_group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = cursorline_group,
    pattern = pattern,
    callback = function() vim.opt_local.cursorline = value end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")

-- Additional options
local options = {
  opt = {
    autoindent = true,
    background = require("user.config").defaults.background,
    completeopt = { "menu", "menuone", "preview", "noselect", "noinsert" },
    -- guifont = { "VictorMono Nerd Font", ":h14" },
    expandtab = true,
    formatoptions = formatoptions(vim.opt),
    incsearch = true,
    laststatus = 3,
    number = true, -- sets vim.opt.number
    relativenumber = true, -- sets vim.opt.relativenumber
    shell = "zsh",
    shiftwidth = 4,
    showmatch = true,
    signcolumn = "auto", -- sets vim.opt.signcolumn to auto
    smartcase = true,
    smoothscroll = true,
    softtabstop = 4,
    spell = false, -- sets vim.opt.spell
    splitkeep = "screen",
    tabstop = 4,
    termguicolors = true,
    updatetime = 200,
    wrap = false, -- sets vim.opt.wrap
  },
  g = {
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    autopairs_enabled = true, -- enable autopairs at start
    cmp_enabled = true, -- enable completion at start
    diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)

    -- Turn off warnings related to certain languages
    loaded_perl_provider = 0,
    loaded_ruby_provider = 0,

    -- Disabled for Noice plugin
    lsp_handlers_enabled = false, -- enable or disable default vim.lsp.handlers (hover and signature help)
    mapleader = " ", -- sets vim.g.mapleader
    -- resession_enabled = true, -- enable experimental resession.nvim session management (will be default in AstroNvim v4)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements

    -- Custom optons: Initialize variable, not strictly necessary, automatically set by autocmd
    colorscheme_bg = "dark",
  },
}

-- neovide specific
if vim.g.neovide then
  options.opt.guifont = "JetBrainsMono Nerd Font,VictorMono Nerd Font"
  -- options.g.neovide_scale_factor = 0.3
end

-- If you need more control, you can use the function()...end notation
-- return function(local_vim)
--   local_vim.opt.relativenumber = true
--   local_vim.g.mapleader = " "
--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
--
--   return local_vim
-- end

return options
