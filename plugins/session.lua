local function tab_buf_filter(tabpage, bufnr)
  local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))
  return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir) and vim.tbl_contains(vim.t[tabpage].bufs, bufnr)
end

return {
  {
    "stevearc/resession.nvim",
    opts = {
      autosave = {
        notify = true,
      },
      tab_scoped = true,
      buf_filter = function(bufnr) return require("astronvim.utils.buffer").is_restorable(bufnr) end,
      tab_buf_filter = tab_buf_filter,
    },
    config = function(_, opts) require("resession").setup(opts) end,
  },
  {
    "jay-babu/project.nvim",
    event = "VeryLazy",
    name = "project_nvim",
    opts = {
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        "pyproject.toml",
        "Cargo.toml",
        "requirements.txt",
        "src/",
      },
      ignore_lsp = { "lua_ls" },
      exclude_dirs = {
        "~/.cargo/*",
        "~/Downloads/*",
        "~/.nvm/*",
        "~/.npm/",
        "~/.cache/*",
        "~/.vscode/",
      },
      silent_chdir = false,
      show_hidden = true,
    },
    config = function(_, opts) require("project_nvim").setup(opts) end,
  },
}
