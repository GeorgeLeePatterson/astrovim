local cmp_utils = require "user.plugins.config.cmp"

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
        { name = "nvim_lsp_signature_help", priority = 1000 },
        { name = "nvim_lsp", priority = 800, keyword_length = 1 },
        { name = "nvim_lua", priority = 700, keyword_length = 1 },
        {
          name = "buffer",
          priority = 600,
          keyword_length = 3,
          options = {
            get_bufnrs = function() -- from all buffers (less than 1MB)
              local bufs = {}
              for _, bufn in ipairs(vim.api.nvim_list_bufs()) do
                local buf_size = vim.api.nvim_buf_get_offset(bufn, vim.api.nvim_buf_line_count(bufn))
                if buf_size < 1024 * 1024 then table.insert(bufs, bufn) end
              end
              return bufs
            end,
          },
        },
        { name = "luasnip", priority = 600 },
        { name = "path", priority = 250 },
      }

      -- Inside formatting
      opts.formatting.fields = { "kind", "abbr", "menu" }
      opts.formatting.format = cmp_utils.format_suggestion

      -- luasnip configuration
      opts.snippet.expand = function(args) require("luasnip").lsp_expand(args.body) end

      -- Sorting
      local compare = require "cmp.config.compare"
      opts.sorting = {
        comparators = {
          compare.offset,
          compare.exact,
          cmp_utils.lspkind_comparator {},
          compare.recently_used,
          compare.score,
          compare.order,
        },
      }
      -- Window formatting
      opts.window.completion = {
        border = "rounded",
        winhighlight = "Normal:Pmenu,Search:None,FloatBorder:BorderOnly", --
        col_offset = -4,
        side_padding = 0,
      }
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)

      -- configure `cmp-cmdline` as described in their repo: https://github.com/hrsh7th/cmp-cmdline#setup
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        window = { completion = cmp.config.window.bordered { col_offset = 0 } },
        formatting = { fields = { "abbr" } },
        sources = cmp.config.sources({
          name = "nvim_lsp_document_symbol",
        }, {
          { name = "buffer" },
        }),
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        window = { completion = cmp.config.window.bordered { col_offset = 0 } },
        formatting = { fields = { "abbr" } },
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
    -- opts = function(_, opts) cmp_utils.lsp_kind_opts(cmp_utils.lsp_kind_opts(opts)) end,
  },
}
