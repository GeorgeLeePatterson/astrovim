return {
  options = {
    -- stylua: ignore
    close_command = function(n) require("mini.bufremove").delete(n, false) end,
    -- stylua: ignore
    right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "center",
        padding = 0,
      },
    },
    themable = true,
    indicator = {
      icon = " ",
      style = "icon",
    },
    diagnostics_indicator = function(_, _, diag)
      local icons = require("user.config").icons.diagnostics
      local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        .. (diag.warning and icons.Warn .. diag.warning or "")
      return vim.trim(ret)
    end,
    diagnostics_update_in_insert = true,
    show_tab_indicators = true,
    separator_style = "slope",
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
  },
}
