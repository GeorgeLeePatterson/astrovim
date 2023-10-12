---@diagnostic disable: param-type-mismatch
local M = {}

local api = vim.api
local fn = vim.fn
local bo = vim.bo

local heirline = require "heirline.utils"

local astro_conditions = require "astronvim.utils.status.condition"
local astro_status = require "astronvim.utils.status"

local util = require "user.utils.heirline.util"
local icons = util.icons
local mode = util.mode

local theme = require "user.utils.heirline.theme"
local hl = theme.highlight
local colors = theme.colors

local hl_colors = require("user.utils.colors").generate_hls()

vim.o.showmode = false

-- Flexible components priorities
-- local priority = {
--   CurrentPath = 60,
--   Git = 40,
--   WorkDir = 25,
--   Lsp = 10,
-- }

local Align, Space, ReadOnly
do
  Align = setmetatable({ provider = "%=" }, {
    __call = function(_, opts)
      opts = opts or {}
      opts.provider = "%="
      return opts
    end,
  })
  Space = setmetatable({ provider = " " }, {
    __call = function(_, n, opts) return vim.tbl_deep_extend("force", { provider = string.rep(" ", n) }, opts or {}) end,
  })
  local _ReadOnly = {
    condition = function() return not bo.modifiable or bo.readonly end,
    provider = icons.padlock,
    hl = hl.ReadOnly,
  }
  ReadOnly = setmetatable(_ReadOnly, {
    __call = function(_, opts)
      opts = opts or {}
      opts.condition = opts.condition or _ReadOnly.condition
      opts.provider = opts.provider or _ReadOnly.provider
      opts.hl = opts.hl or _ReadOnly.hl
      return opts
    end,
  })
end

local Indicator
do
  local VimMode
  do
    local NormalModeIndicator = {
      Space(1, { hl = hl.StatusLineDark }),
      {
        fallthrough = false,
        {
          provider = icons.pacman .. " ",
          hl = function()
            local mode_hl = hl.StatusLineDark
            if bo.modified then
              mode_hl.fg = colors.blue2
            else
              mode_hl.fg = hl_colors["YellowCustomFg"].fg
            end
            return mode_hl
          end,
        },
      },
      util.IconProvider(icons.powerline.right_filled, { hl = { fg = hl.StatusLineDark.bg } }),
    }

    local ActiveModeIndicator = {
      condition = function(self) return self.mode ~= "normal" end,
      hl = { bg = hl.StatusLine.bg },
      heirline.surround(
        { icons.powerline.block, icons.powerline.block .. icons.powerline.right_filled },
        function(self) -- color
          return hl.Mode[self.mode].bg
        end,
        {
          {
            fallthrough = false,
            { provider = icons.pacman },
          },
          Space,
          { provider = function(self) return util.mode_label[self.mode] end },
          hl = function(self) return hl.Mode[self.mode] end,
        }
      ),
    }

    VimMode = {
      init = function(self)
        self.mode = mode[fn.mode(1)] -- :h mode()
      end,
      condition = function() return bo.buftype == "" end,
      {
        fallthrough = false,
        ActiveModeIndicator,
        NormalModeIndicator,
      },
    }
  end

  Indicator = {
    fallthrough = false,
    VimMode,
  }
end

M.StatusLines = {
  init = function(self)
    local names = {}
    local bufnr = api.nvim_get_current_buf()
    for _, server in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
      table.insert(names, server.name)
    end
    self.lsp_names = names

    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    self.has_diagnostics = self.errors > 0 or self.warnings > 0 or self.hints > 0 or self.info > 0
  end,
  hl = { fg = "fg", bg = "bg" }, -- hl.StatusLine,
  {
    -- Mode & Cmd information
    Indicator,
    astro_status.component.cmd_info(),

    -- File information
    astro_status.component.file_info { -- file icon
      filetype = false,
      filename = false,
      file_modified = false,
      surround = {
        separator = { "", "" },
        color = "file_info_bg",
      },
      condition = function() return astro_conditions.has_filetype(nil) and bo.buftype == "" end,
    },
    util.IconProvider(icons.powerline.left_filled .. icons.powerline.block, {
      hl = { fg = hl.StatusLineDark.bg },
      condition = astro_conditions.has_filetype,
    }),
    astro_status.component.file_info { -- file name
      filetype = false,
      filename = {},
      file_icon = false,
      file_modified = false,
      hl = hl.StatusLineDark,
      surround = {
        separator = { "", "" },
        condition = astro_conditions.has_filetype,
      },
    },

    -- Git information
    util.IconProvider(icons.powerline.block .. icons.powerline.right_filled, {
      hl = function(self) return theme.lsp_server_accent(self.lsp_names) end,
      condition = astro_conditions.has_filetype,
    }),
    astro_status.component.git_branch {
      surround = {
        separator = { " ", " " },
        color = function(self) return theme.lsp_server_surround(self.lsp_names, { "main", "left", "right" }) end,
      },
      hl = { fg = hl.StatusLineDark.bg },
    },
    util.IconProvider(icons.powerline.left_filled .. icons.powerline.block, {
      hl = function(self) return theme.lsp_server_accent(self.lsp_names) end,
    }),

    -- Diagnostic information
    astro_status.utils.surround({ "", "" }, hl.StatusDark, {
      ReadOnly {
        hl = { bg = hl.StatusLineDark.bg },
      },
      astro_status.component.git_diff {
        hl = hl.StatusLineDark,
        surround = {
          separator = { "", "" },
          condition = astro_conditions.has_filetype,
        },
      },
      astro_status.component.diagnostics {
        hl = hl.StatusLineDark,
        surround = {
          separator = { "", "" },
          condition = astro_conditions.has_filetype,
        },
      },
      {
        provider = "  ",
        hl = { fg = hl_colors["LawngreenCustomFg"].fg, bg = hl.StatusLineDark.bg },
        condition = function(self) return not self.has_diagnostics and bo.buftype == "" end,
      },
    }, nil),
    util.IconProvider(icons.powerline.block .. icons.powerline.right_filled, {
      hl = { fg = hl.StatusLineDark.bg },
    }),

    -- LSP information
    Align,
    astro_status.component.lsp {},
    Align,

    -- Treesitter information
    astro_status.component.treesitter {
      surround = {
        separator = { icons.powerline.left_filled .. icons.powerline.block, "" },
        color = { main = hl.StatusLineDark.bg },
      },
    },

    -- File type
    util.IconProvider(icons.powerline.block .. icons.powerline.right_filled, {
      hl = function(self) return theme.lsp_server_accent(self.lsp_names) end,
    }),
    astro_status.component.file_info {
      filetype = {},
      filename = false,
      file_modified = false,
      file_icon = false,
      surround = {
        separator = { " ", " " },
        color = function(self) return theme.lsp_server_surround(self.lsp_names, { "main", "left", "right" }) end,
      },
      hl = { fg = hl.StatusLineDark.bg },
    },
    util.IconProvider(icons.powerline.left_filled .. icons.powerline.block, {
      hl = function(self) return theme.lsp_server_accent(self.lsp_names) end,
    }),

    -- Nav information
    astro_status.component.nav {
      surround = {
        separator = { "", "" },
        color = hl.StatusLineDark.bg,
      },
    },
  },
}

return M
