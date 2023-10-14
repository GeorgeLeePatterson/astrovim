local ufo_config = require "user.plugins.config.ufo"

return {
  -- Layout
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        left = { size = 40 },
        bottom = { size = 10 },
        right = { size = 40 },
        top = { size = 10 },
      },
      bottom = {
        {
          ft = "toggleterm",
          title = "TERMINAL",
          size = { height = 0.4 },
          filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
        },
        { ft = "spectre_panel", title = "SPECTRE", size = { height = 0.4 } },
        { ft = "Trouble", title = "TROUBLE" },
        { ft = "qf", title = "QUICKFIX" },
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf) return vim.bo[buf].buftype == "help" end,
        },
      },
      left = {
        {
          title = "  FILE",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
          size = { height = 0.7 },
        },
        {
          title = "  GIT",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "git_status" end,
          pinned = true,
          open = "Neotree position=right git_status",
        },
        {
          title = "  BUFFERS",
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "buffers" end,
          pinned = true,
          open = "Neotree position=top buffers",
        },
        {
          title = "  OUTLINE",
          ft = "Outline",
          pinned = true,
          open = "SymbolsOutline",
        },
        -- {
        --   ft = "裂 DIAGNOSTICS",
        --   filter = function(buf) return vim.b[buf].neo_tree_source == "diagnostics" end,
        --   pinned = true,
        --   open = "Neotree position=right diagnostics",
        -- },
        "neo-tree",
      },
    },
  },
  -- Symbols
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>vs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      position = "right",
    },
  },
  -- Markdown
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  {
    "plasticboy/vim-markdown",
    dependencies = "godlygeek/tabular",
    ft = "markdown",
    event = "VeryLazy",
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_toc_autofit = 1
      vim.g.vim_markdown_follow_anchor = 1
      vim.g.vim_markdown_conceal = 1
      vim.g.vim_markdown_conceal_code_blocks = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_new_list_item_indent = 4
      vim.g.vim_markdown_edit_url_in = "tab"

      vim.o.conceallevel = 3
      vim.g.tex_conceal = ""

      vim.api.nvim_create_augroup("Markdown", { clear = true })
      vim.api.nvim_create_autocmd("Filetype", {
        group = "Markdown",
        pattern = { "markdown" },
        callback = function() vim.keymap.set("x", "<C-Enter>", ":<C-U>TableFormat<CR>", { silent = true }) end,
      })
    end,
  },
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "markdown",
    event = "VeryLazy",
    config = function()
      require("headlines").setup {
        markdown = {
          query = vim.treesitter.query.parse(
            "markdown",
            [[
              (atx_heading [
                (atx_h1_marker)
                (atx_h2_marker)
                (atx_h3_marker)
                (atx_h4_marker)
                (atx_h5_marker)
                (atx_h6_marker)
              ] @headline)

              (thematic_break) @dash

              (fenced_code_block) @codeblock

              (block_quote_marker) @quote
              (block_quote (paragraph (inline (block_continuation) @quote)))
            ]]
          ),
          headline_highlights = {
            "Headline1",
            "Headline2",
            "Headline3",
            "Headline4",
            "Headline5",
            "Headline6",
          },
          codeblock_highlight = "CodeBlock",
          dash_highlight = "Dash",
          dash_string = "-",
          quote_highlight = "Quote",
          quote_string = "┃",
          fat_headlines = true,
          fat_headline_upper_string = "▃",
          fat_headline_lower_string = "🬂",
        },
      }

      vim.api.nvim_set_hl(0, "Headline1", { fg = "#cb7676", bg = "#402626", italic = false })
      vim.api.nvim_set_hl(0, "Headline2", { fg = "#c99076", bg = "#66493c", italic = false })
      vim.api.nvim_set_hl(0, "Headline3", { fg = "#80a665", bg = "#3d4f2f", italic = false })
      vim.api.nvim_set_hl(0, "Headline4", { fg = "#4c9a91", bg = "#224541", italic = false })
      vim.api.nvim_set_hl(0, "Headline5", { fg = "#6893bf", bg = "#2b3d4f", italic = false })
      vim.api.nvim_set_hl(0, "Headline6", { fg = "#d3869b", bg = "#6b454f", italic = false })
      vim.api.nvim_set_hl(0, "CodeBlock", { bg = "#444444" })
    end,
  },
  {
    "toppair/peek.nvim",
    event = { "BufRead", "BufNewFile" },
    ft = { "markdown" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },

  -- Searching
  {
    "ray-x/sad.nvim",
    cmd = "Sad",
    dependencies = {
      { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
    },
    keys = {
      {
        "<leader>ss",
        function() vim.cmd(":Sad " .. vim.fn.input "Enter search pattern: ") end,
        mode = { "n", "v", "s" },
        desc = "Sad s&r (cursor)",
      },
    },
    config = function() require("sad").setup {} end,
  },
  {
    "AckslD/muren.nvim",
    cmd = { "MurenOpen", "MurenFresh", "MurenUnique" },
    event = { "BufNewFile", "BufAdd" },
    keys = {
      {
        "<leader>sn",
        function() vim.cmd [[MurenOpen]] end,
      },
    },
    config = function()
      require("muren").setup {
        anchor = "bottom_right",
      }
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      {
        "<leader>so",
        function() vim.cmd [[Spectre]] end,
        mode = { "n", "v", "s" },
        desc = "Start spectre search",
      },
    },
    opts = function()
      local prefix = "<leader>s"
      return {
        open_cmd = "new",
        mapping = {
          send_to_qf = { map = prefix .. "q" },
          replace_cmd = { map = prefix .. "c" },
          show_option_menu = { map = prefix .. "o" },
          run_current_replace = { map = prefix .. "C" },
          run_replace = { map = prefix .. "R" },
          change_view_mode = { map = prefix .. "v" },
          resume_last_search = { map = prefix .. "l" },
        },
      }
    end,
  },

  -- Folding
  {
    "kevinhwang91/nvim-ufo",
    config = function(_, opts)
      opts.fold_virt_text_handler = ufo_config.handler
      require("ufo").setup(opts)
    end,
  },
}
