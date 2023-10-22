return {
  -- [[ Statusline ]]
  {
    "rebelot/heirline.nvim",
    dependencies = {
      "akinsho/horizon.nvim",
      "sainnhe/gruvbox-material",
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-web-devicons",
    },
    opts = function(_, opts) return require "user.plugins.config.heirline"(opts) end,
    config = require "plugins.configs.heirline",
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    opts = function()
      local Offset = require "bufferline.offset"
      if not Offset.edgy then
        local get = Offset.get
        ---@diagnostic disable-next-line: duplicate-set-field
        Offset.get = function()
          if package.loaded.edgy then
            local layout = require("edgy.config").layout
            local ret = { left = "", left_size = 0, right = "", right_size = 0 }
            for _, pos in ipairs { "left", "right" } do
              local sb = layout[pos]
              if sb and #sb.wins > 0 then
                local title = "  SIDEBAR " .. string.rep(" ", sb.bounds.width - 8)
                ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
                ret[pos .. "_size"] = sb.bounds.width
              end
            end
            ret.total_size = ret.left_size + ret.right_size
            if ret.total_size > 0 then return ret end
          end
          return get()
        end
        Offset.edgy = true
      end
      return require "user.plugins.config.bufferline"
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufNew" }, {
        callback = function()
          vim.schedule(function() pcall(nvim_bufferline) end)
        end,
      })
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPre",
    keys = {
      {
        "g<Tab>",
        function() require("dropbar.api").pick() end,
        mode = { "n" },
        desc = "Dropbar Nav",
      },
    },
    config = function()
      require("dropbar").setup {
        icons = {
          kinds = require("user.plugins.config.dropbar").kinds,
        },
      }
    end,
  },
  -- Only here to provide themes to astronvim heirline
  "nvim-lualine/lualine.nvim",

  -- [[ Ui ]]
  {
    "rcarriga/nvim-notify",
    branch = "master",
    event = "VimEnter",
    keys = {
      {
        "<leader>vC",
        function() require("notify").dismiss { silent = true, pending = true } end,
        mode = { "n" },
        desc = "Clear all notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      -- on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
      -- render = "compact",
    },
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    event = "VeryLazy",
    keys = {
      { "<leader>Nl", function() require("noice").cmd "last" end, desc = "Noice Last Message" },
      { "<leader>Nh", function() require("noice").cmd "history" end, desc = "Noice History" },
      { "<leader>Na", function() require("noice").cmd "all" end, desc = "Noice All" },
      { "<leader>Nd", function() require("noice").cmd "dismiss" end, desc = "Dismiss All" },
    },
    opts = require "user.plugins.config.noice",
  },
  {
    "stevearc/dressing.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = { char = "▏" },
      scope = { show_start = false, show_end = false },
      exclude = {
        buftypes = {
          "nofile",
          "terminal",
        },
        filetypes = {
          "aerial",
          "alpha",
          "dashboard",
          "help",
          "lazy",
          "mason",
          "neogitstatus",
          "NvimTree",
          "neo-tree",
          "startify",
          "toggleterm",
          "Trouble",
        },
      },
    },
    config = function(_, opts)
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup(vim.tbl_deep_extend("force", opts, { scope = { highlight = highlight } }))

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
}
