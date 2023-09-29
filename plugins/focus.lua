local ignore_filetypes = { "neo-tree" }
local ignore_buftypes = { "nofile", "prompt", "popup" }

local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      vim.api.nvim_win_set_var(0, "focus_disable", true)
    else
      vim.api.nvim_win_set_var(0, "focus_disable", false)
    end
  end,
  desc = "Disable focus autoresize for BufType",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.api.nvim_win_set_var(0, "focus_disable", true)
    else
      vim.api.nvim_win_set_var(0, "focus_disable", false)
    end
  end,
  desc = "Disable focus autoresize for FileType",
})

return {
  {
    "nvim-focus/focus.nvim",
    version = false,
    enabled = false,
    event = "VeryLazy",
    opts = {
      ui = { winhighlight = true },
    },
    config = function(_, opts) require("focus").setup(opts) end,
  },
}
