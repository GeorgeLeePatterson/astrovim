local function get_session_name()
  local name = vim.fn.getcwd()
  local branch = vim.trim(vim.fn.system "git branch --show-current")
  if vim.v.shell_error == 0 then
    return name .. branch
  else
    return name
  end
end

return {
  {
    "stevearc/resession.nvim",
    priority = 900,
    config = function(_, opts)
      require("resession").setup(opts)

      -- Save one session per git
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            require("resession").load(get_session_name(), { dir = "dirsession", silence_errors = true })
          end
        end,
      })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function() require("resession").save(get_session_name(), { dir = "dirsession", notify = false }) end,
      })
    end,
  },
}
