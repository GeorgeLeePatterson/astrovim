return {
  lsp = {
    hover = {
      enabled = true,
    },
    signature = {
      enabled = true,
    },
    -- override markdown rendering so that cmp and other plugins use Treesitter
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
        },
      },
      view = "mini",
    },
  },
  views = {
    cmdline_popup = {
      position = {
        row = "50%",
        col = "50%",
      },
      size = {
        width = "40%",
        height = "auto",
      },
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
      relative = "editor",
      size = {
        width = "40%",
        height = "auto",
      },
      border = {
        padding = { 0, 1 },
      },
    },
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    inc_rename = true,
    long_message_to_split = true,
    -- lsp_doc_border = true,
  },
}
