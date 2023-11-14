return {
  options = {
    left = {
      size = function()
        if vim.opt.columns:get() < 200 then
          return 30
        else
          return 40
        end
      end,
    },
    bottom = { size = 10 },
    right = {
      size = function()
        if vim.opt.columns:get() < 200 then
          return 30
        else
          return 40
        end
      end,
    },
    top = { size = 10 },
  },
  bottom = {
    {
      ft = "toggleterm",
      title = "TERMINAL",
      size = { height = 0.4 },
      filter = function(_, win)
        return vim.api.nvim_win_get_config(win).relative == ""
      end,
    },
    {
      ft = "noice",
      title = "NOICE",
      size = { height = 0.4 },
      filter = function(_, win)
        return vim.api.nvim_win_get_config(win).relative == ""
      end,
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
      title = "  FILES",
      ft = "neo-tree",
      filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
      pinned = true,
      open = "Neotree filesystem",
      size = { height = 0.5 },
    },
    -- {
    --   title = "  GIT",
    --   ft = "neo-tree",
    --   filter = function(buf) return vim.b[buf].neo_tree_source == "git_status" end,
    --   pinned = true,
    --   open = "Neotree position=right git_status",
    -- },
    -- {
    --   title = "  BUFFERS",
    --   ft = "neo-tree",
    --   filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end,
    --   pinned = true,
    --   open = "Neotree position=top buffers",
    -- },
    {
      title = "  OUTLINE",
      ft = "Outline",
      pinned = true,
      open = function()
        if pcall(require, "symbols-outline") then
          vim.cmd [[SymbolsOutlineOpen]]
        end
      end,
      size = { height = 0.4 },
    },
    -- "neo-tree",
    -- -- Disabled to free up real estate.
    -- {
    --   ft = "裂 DIAGNOSTICS",
    --   filter = function(buf) return vim.b[buf].neo_tree_source == "diagnostics" end,
    --   pinned = true,
    --   open = "Neotree position=right diagnostics",
    -- },
  },
  -- right = {
  --   ft = "aerial",
  --   title = "Aerial",
  --   size = { width = 0.2 },
  --   filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
  -- },
}
