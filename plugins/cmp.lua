local cmp_utils = require "user.plugins.config.cmp"

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    keys = { ":", "/", "?" },
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "neovim/nvim-lspconfig",
      "simrat39/rust-tools.nvim",
      -- "zbirenbaum/copilot-cmp",
    },
    opts = function(_, opts)
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end
      local cmp = require "cmp"
      local compare = require "cmp.config.compare"
      local luasnip = require "luasnip"

      -- Sources
      opts.source = cmp.config.sources {
        -- { name = "copilot", priority = 900 },
        { name = "nvim_lsp", priority = 800, keyword_length = 3 },
        { name = "nvim_lua", priority = 700, keyword_length = 2 },
        { name = "nvim_lsp_signature_help", priority = 700 },
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
        { name = "luasnip", priority = 600, keyword_length = 3 },
        { name = "path", priority = 250 },
      }

      -- Inside formatting
      opts.formatting.fields = { "kind", "abbr", "menu" }
      opts.formatting.format = cmp_utils.format_suggestionsigncolumn

      -- Sorting
      opts.sorting = {
        comparators = {
          compare.offset,
          compare.exact,
          -- require("copilot_cmp.comparators").prioritize,
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

      -- Mapping
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping.confirm { select = false },

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      opts.preselect = cmp.PreselectMode.None
      -- Ghost text
      opts.experimental = {
        ghost_text = {
          hl_group = "CmpGhostTest",
        },
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
        sources = cmp.config.sources {
          { name = "buffer" },
        },
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
  { "onsails/lspkind.nvim" },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 50,
          keymap = {
            accept = false,
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      }
    end,
  },
}
