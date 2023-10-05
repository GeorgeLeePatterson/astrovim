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

return M
