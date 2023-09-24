return {
  "rcarriga/nvim-notify",
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    event = "VeryLazy",
    config = function()
      require("noice").setup {
        lsp = {
          hover = {
            enabled = true,
            opts = {
              replace = true,
              render = "plain",
              format = { "kind", "abbr", "menu" },
              win_options = { concealcursor = "n", conceallevel = 3 },
            },
          },
          signature = {
            enabled = true,
            opts = {
              replace = true,
              render = "plain",
              format = { "kind", "abbr", "menu" },
              win_options = { concealcursor = "n", conceallevel = 3 },
            },
          },
          -- override markdown rendering so that cmp and other plugins use Treesitter
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        views = {
          cmdline_popup = {
            position = {
              row = "50%",
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
          },
          popupmenu = {
            enabled = true,
            backend = "nui",
            relative = "editor",
            position = {
              row = 8,
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = {
                Normal = "Normal",
                FloatBorder = "DiagnosticInfo",
              },
            },
          },
        },
        presets = {
          bottom_search = false,
          command_palette = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
      }
    end,
  },
}
