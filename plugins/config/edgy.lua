return {
  options = {
    left = { size = 40 },
    bottom = { size = 10 },
    right = { size = 40 },
    top = { size = 10 },
  },
  bottom = {
    {
      ft = "toggleterm",
      title = "TERMINAL",
      size = { height = 0.4 },
      filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
    },
    {
      ft = "noice",
      title = "NOICE",
      size = { height = 0.4 },
      filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
    },
    { ft = "spectre_panel", title = "SPECTRE", size = { height = 0.4 } },
    { ft = "Trouble", title = "TROUBLE" },
    { ft = "qf", title = "QUICKFIX" },
    {
      ft = "help",
      size = { height = 20 },
      -- only show help buffers
      filter = function(buf) return vim.bo[buf].buftype == "help" end,
    },
  },
  left = {
    {
      title = "  FILE",
      ft = "neo-tree",
      filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
      pinned = true,
      open = "Neotree filesystem",
      -- open = function()
      --   if package.loaded["neo-tree"] then vim.cmd [[Neotree source-filesystem close]] end
      --   vim.cmd [[Neotree source=filesystem]]
      -- end,
      size = { height = 0.6 },
    },
    -- -- Disabled to free up real estate.
    -- {
    --   title = "  GIT",
    --   ft = "neo-tree",
    --   filter = function(buf) return vim.b[buf].neo_tree_source == "git_status" end,
    --   pinned = true,
    --   open = "Neotree position=right git_status",
    -- },
    {
      title = "  BUFFERS",
      ft = "neo-tree",
      filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end,
      pinned = true,
      open = "Neotree position=top buffers",
    },
    {
      title = "  OUTLINE",
      ft = "Outline",
      pinned = true,
      open = "SymbolsOutline",
    },
    -- {
    --   ft = "裂 DIAGNOSTICS",
    --   filter = function(buf) return vim.b[buf].neo_tree_source == "diagnostics" end,
    --   pinned = true,
    --   open = "Neotree position=right diagnostics",
    -- },
    "neo-tree",
  },
  -- right = {
  --   ft = "aerial",
  --   title = "Aerial",
  --   size = { width = 0.2 },
  --   filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
  -- },
}
