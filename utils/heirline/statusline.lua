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
local get_mode = util.get_mode

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
    __call = function(_, n, opts)
      return vim.tbl_deep_extend(
        "force",
        { provider = string.rep(" ", n) },
        opts or {}
      )
    end,
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
      util.IconProvider(
        icons.powerline.right_filled,
        { hl = { fg = hl.StatusLineDark.bg } }
      ),
    }

    local ActiveModeIndicator = {
      condition = function(self) return self.mode ~= "normal" end,
      -- hl = { bg = hl.StatusLine.bg },
      heirline.surround({
        icons.powerline.block,
        icons.powerline.block .. icons.powerline.right_filled,
      }, function(self) -- color
        return hl.Mode[self.mode].bg
      end, {
        { provider = icons.pacman },
        Space,
        { provider = function(self) return util.mode_label[self.mode] end },
        hl = function(self) return hl.Mode[self.mode] end,
      }),
    }

    VimMode = {
      init = function(self)
        self.mode = get_mode(fn.mode(1)) -- :h mode()
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
      },
      -- condition = function() return bo.buftype == "" end,
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

local FileIcon = function()
  return astro_status.component.file_info { -- file icon
    filetype = false,
    filename = false,
    file_modified = false,
    surround = { separator = { "", "" }, color = "file_info_bg" },
    condition = function()
      return astro_conditions.has_filetype(nil) and bo.buftype == ""
    end,
  }
end

local FileName = function()
  return util.CalloutSection(
    astro_status.component.file_info { -- file name
      filetype = false,
      filename = {},
      file_modified = { padding = { left = 1, right = 1 }, hl = hl.ReadOnly },
      file_icon = false,
      surround = false,
      hl = function() return theme.get_callout_hl(true) end,
    },
    {
      surround = {
        icons.powerline.left_filled .. icons.powerline.block,
        icons.powerline.block .. icons.powerline.right_filled,
      },
      hl = function() return theme.get_callout_hl()["bg"] end,
    }
  )
end

local Diagnostics = function()
  return util.CalloutSection({
    ReadOnly,
    astro_status.component.git_diff { surround = false },
    {
      provider = " ",
      condition = function()
        return astro_conditions.git_changed(0) and bo.buftype == ""
      end,
    },
    theme.get_special_separator("slant_right", {
      condition = function()
        return astro_conditions.git_changed(0) and bo.buftype == ""
      end,
    }),
    astro_status.component.diagnostics { surround = false },
    {
      provider = "  ",
      hl = function() return { fg = hl_colors["ForestgreenCustomFg"].fg } end,
      condition = function(self)
        return not self.has_diagnostics and bo.buftype == ""
      end,
    },
    update = { "DiagnosticChanged", "BufEnter" },
  }, {
    surround = {
      icons.powerline.left_filled .. icons.powerline.block,
      icons.powerline.block .. icons.powerline.slant_right, -- right_filled,
    },
    hl = function() return theme.get_callout_hl()["bg"] end,
  })
end

local Treesitter = function()
  return util.CalloutSection(
    astro_status.component.treesitter {
      surround = false,
      hl = function() return theme.get_callout_hl() end,
    },
    {
      surround = {
        -- util.separators.slant_left,
        icons.powerline.slant_left .. icons.powerline.block,
        -- icons.powerline.left_filled .. icons.powerline.block,
        icons.powerline.block .. icons.powerline.right_filled,
      },
      right = function(self) return theme.lsp_server_accent(self.lsp_names).bg end,
      -- left = function() return theme.get_callout_hl()["fg"] end,
      hl = function() return theme.get_callout_hl()["bg"] end,
    }
  )
end

local Nav = function()
  return util.CalloutSection(
    astro_status.component.nav {
      surround = false,
      hl = function() return theme.get_callout_hl(true) end,
    },
    {
      surround = {
        icons.powerline.left_filled .. icons.powerline.block,
        "",
      },
      left = function(self) return theme.lsp_server_accent(self.lsp_names).bg end,
      hl = function() return theme.get_callout_hl()["bg"] end,
    }
  )
end

M.StatusLines = {
  init = function(self)
    local names = {}
    local bufnr = api.nvim_get_current_buf()
    for _, server in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
      table.insert(names, server.name)
    end

    self.lsp_names = names
    self.errors =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info =
      #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    self.has_diagnostics = self.errors > 0
      or self.warnings > 0
      or self.hints > 0
      or self.info > 0
  end,
  hl = { fg = "fg", bg = "bg" }, -- hl.StatusLine,
  {
    -- Mode & Cmd information
    Indicator,
    astro_status.component.cmd_info(),

    -- File info
    FileIcon(),
    FileName(),

    -- Git information
    astro_status.component.git_branch {
      surround = { separator = { " ", " " } },
    },

    -- Diagnostic information
    Diagnostics(),

    -- LSP information
    Align,
    astro_status.component.lsp {},
    Align,

    -- Treesitter information

    Treesitter(),

    -- File type
    astro_status.component.file_info {
      filetype = {},
      filename = false,
      file_modified = false,
      file_icon = false,
      surround = {
        separator = { " ", " " },
        color = function(self)
          return theme.lsp_server_surround(
            self.lsp_names,
            { "main", "left", "right" }
          )
        end,
      },
      hl = { fg = theme.get_callout_hl()["bg"] },
    },

    -- Nav information
    Nav(),
  },
}

return M
