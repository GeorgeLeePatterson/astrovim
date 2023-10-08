local icons = require("user.config").icons
local user_utils = require "user.utils"
local longest_kind_type = user_utils.longest_line(vim.tbl_keys(icons.kinds))

local M = {}

M.default_kind_priority = {
  Copilot = 13,
  Field = 13,
  Property = 12,
  Module = 11,
  Method = 11,
  Function = 10,
  Constant = 10,
  Enum = 10,
  EnumMember = 10,
  Event = 10,
  Operator = 10,
  Reference = 10,
  Struct = 10,
  Variable = 9,
  File = 8,
  Folder = 8,
  Class = 5,
  Color = 5,
  Keyword = 2,
  Constructor = 1,
  Interface = 1,
  Snippet = 0,
  Text = 1,
  TypeParameter = 1,
  Unit = 1,
  Value = 1,
}

M.lsp_kind_opts = function(opts)
  opts.mode = "symbol_text"
  opts.symbol_map = icons.kinds
  opts.menu = icons.cmp_sources
  opts.maxwidth = 50
  opts.ellipsis_char = "..."
  return opts
end

function M.lspkind_comparator(conf)
  conf.kind_priority = vim.tbl_deep_extend("force", M.default_kind_priority, (conf.kind_priority or {}) or {})
  local lsp_types = require("cmp.types").lsp
  return function(entry1, entry2)
    if entry1.source.name ~= "nvim_lsp" then
      if entry2.source.name == "nvim_lsp" then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

    local priority1 = conf.kind_priority[kind1] or 0
    local priority2 = conf.kind_priority[kind2] or 0
    if priority1 == priority2 then return nil end
    return priority2 < priority1
  end
end

-- Format suggestions
function M.format_suggestion(entry, vim_item)
  local default_lsp_kind_opts = M.lsp_kind_opts {}
  local parts = require("lspkind").cmp_format(default_lsp_kind_opts)(entry, vim_item)
  local original_menu = parts.menu

  -- split `kind` to separate icon and actual `type`
  local strings = vim.split(parts.kind, "%s", { trimempty = true })
  parts.kind = " " .. (strings[1] or "") .. " "

  -- Combine Kind `type` and Menu
  parts.menu = "    " .. (strings[2] or "") .. " "
  parts.menu = user_utils.str_pad_len(parts.menu, longest_kind_type) .. "  "
  if original_menu then parts.menu = parts.menu .. original_menu end

  return parts
end

function M.opts(_, o)
  vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
  end
  local cmp = require "cmp"
  local compare = require "cmp.config.compare"
  local luasnip = require "luasnip"

  local opts = vim.tbl_deep_extend("force", o, {
    -- Sources
    sources = cmp.config.sources {
      { name = "nvim_lsp", priority = 800, keyword_length = 1 },
      { name = "nvim_lua", priority = 700, keyword_length = 1 },
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
      { name = "luasnip", priority = 600, keyword_length = 2 },
      { name = "path", priority = 250 },
      { name = "emoji" },
    },

    -- Inside formatting
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = M.format_suggestion,
    },

    -- Sorting
    sorting = {
      comparators = {
        compare.offset,
        compare.exact,
        -- require("copilot_cmp.comparators").prioritize,
        M.lspkind_comparator {},
        compare.recently_used,
        compare.score,
        compare.order,
      },
    },

    -- Window formatting
    window = {
      completion = {
        border = "rounded",
        winhighlight = "Normal:Pmenu,Search:None,FloatBorder:BorderOnly", --
        col_offset = -4,
        side_padding = 0,
      },
    },

    -- Mapping
    mapping = vim.tbl_extend("force", o.mapping, {
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
    }),
    preselect = cmp.PreselectMode.None,
    -- Ghost text
    experimental = {
      ghost_text = {
        hl_group = "CmpGhostTest",
      },
    },
  })
  return opts
end

function M.config(_, opts)
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
end

return M
