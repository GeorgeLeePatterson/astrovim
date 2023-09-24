local lsp_kind_opts = function(opts)
  opts.mode = "symbol_text"
  opts.symbol_map = {
    NONE = "",
    Array = "",
    Boolean = "⊨",
    Class = "",
    Constructor = "",
    Key = "",
    Namespace = "",
    Null = "󰟢",
    Number = "#",
    Object = "⦿",
    Package = "",
    Property = "󰜢",
    Reference = "",
    Snippet = "󰅩",
    String = "𝓐",
    TypeParameter = "",
    Unit = "",
  }
  opts.menu = {
    buffer = "[ Buffer]",
    nvim_lsp = "[󱃖 LSP]",
    nvim_lsp_signature_help = "[󰘦 Help]",
    luasnip = "[ LuaSnip]",
    nvim_lua = "[ Lua]",
  }
  return opts
end

return {
  {
    "hrsh7th/nvim-cmp",
    keys = { ":", "/", "?" },
    dependencies = {
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "neovim/nvim-lspconfig",
      "simrat39/rust-tools.nvim",
    },
    opts = function(_, opts)
      local cmp = require "cmp"
      -- Sources
      opts.source = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "nvim_lsp_signature_help", priority = 800 },
        { name = "luasnip", priority = 750 },
        { name = "nvim_lua", priority = 700 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
      }
      -- Inside formatting
      opts.formatting.fields = { "kind", "abbr", "menu" } -- { "abbr", "kind", "menu" }
      opts.formatting.format = function(entry, vim_item)
        local default_lsp_kind_opts = lsp_kind_opts {}
        -- default_lsp_kind_opts.maxwidth = 50
        local kind = require("lspkind").cmp_format(default_lsp_kind_opts)(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"
        return kind
      end

      -- Window formatting
      opts.window.completion = {
        border = "rounded",
        winhighlight = "Normal:Pmenu,Search:None,FloatBorder:BorderOnly", --
        col_offset = -3,
        side_padding = 0,
      }
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)

      -- configure `cmp-cmdline` as described in their repo: https://github.com/hrsh7th/cmp-cmdline#setup
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })

      -- Configure auto parens
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "onsails/lspkind.nvim",
    opts = function(_, opts) lsp_kind_opts(opts) end,
  },
}
