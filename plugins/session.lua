local function tab_buf_filter(tabpage, bufnr)
  local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))
  return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir) and vim.tbl_contains(vim.t[tabpage].bufs, bufnr)
end

local function buf_filter(bufnr)
  local buftype = vim.bo[bufnr].buftype
  if buftype == "help" then return true end
  if buftype ~= "" and buftype ~= "acwrite" then return false end
  if vim.api.nvim_buf_get_name(bufnr) == "" then return false end
  return require("astronvim.utils.buffer").is_restorable(bufnr)
end

return {
  {
    -- Think about re-enabling after removing AstroNvim from setup
    "stevearc/resession.nvim",
    lazy = false,
    enabled = false,
    opts = {
      autosave = {
        notify = true,
      },
      buf_filter = buf_filter,
      -- tab_buf_filter = tab_buf_filter,
    },
    config = function(_, opts) require("resession").setup(opts) end,
  },
  {
    "Shatur/neovim-session-manager",
    enabled = false,
  },
  -- {
  --   "ahmedkhalf/project.nvim",
  --   event = "VeryLazy",
  --   name = "project_nvim",
  --   opts = {
  --     detection_methods = { "pattern", "lsp" },
  --     patterns = {
  --       ".git",
  --       "_darcs",
  --       ".hg",
  --       ".bzr",
  --       ".svn",
  --       "Makefile",
  --       "package.json",
  --       "pyproject.toml",
  --       "Cargo.toml",
  --       "requirements.txt",
  --       "src/",
  --     },
  --     ignore_lsp = { "null-ls", "lua_ls" },
  --     exclude_dirs = {
  --       "~/.cargo/*",
  --       "~/Downloads/*",
  --       "~/.nvm/*",
  --       "~/.npm/",
  --       "~/.cache/*",
  --       "~/.vscode/",
  --     },
  --     silent_chdir = false,
  --     show_hidden = true,
  --     -- scope_chdir = "tab",
  --   },
  --   config = function(_, opts) require("project_nvim").setup(opts) end,
  -- },
}
