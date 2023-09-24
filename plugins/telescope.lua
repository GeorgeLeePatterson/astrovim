return {
  "phaazon/hop.nvim",
  "jay-babu/project.nvim",
  "jvgrootveld/telescope-zoxide",
  "rcarriga/nvim-notify",
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-hop.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "jay-babu/project.nvim",
        name = "project_nvim",
        event = "VeryLazy",
        opts = {
          patterns = {
            ".git",
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
            "Makefile",
            "package.json",
            "pyproject.toml",
            "Cargo.toml",
          },
          ignore_lsp = { "lua_ls" },
        },
      },
      "jvgrootveld/telescope-zoxide",
    },
    opts = function(_, opts)
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local fb_actions = require("telescope").extensions.file_browser.actions
      local lga_actions = require "telescope-live-grep-args.actions"
      local hop = telescope.extensions.hop
      return require("astronvim.utils").extend_tbl(opts, {
        defaults = {
          file_ignore_patterns = {
            "target/debug/*",
            "target/release/*",
            "venv/",
            ".env/*",
            ".cache/*",
            "vendor/*",
            "%.lock",
            "__pycache__/*",
            "%.sqlite3",
            "%.ipynb",
            "node_modules/*",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
            ".git/",
            "%.webp",
            ".dart_tool/",
            ".github/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "env/",
            "gradle/",
            "node_modules/",
            "target/",
            "%.pdb",
            "%.dll",
            "%.class",
            "%.exe",
            "%.cache",
            "%.ico",
            "%.pdf",
            "%.dylib",
            "%.jar",
            "%.docx",
            "%.met",
            "smalljre_*/*",
            ".vale/",
            "%.burp",
            "%.mp4",
            "%.mkv",
            "%.rar",
            "%.zip",
            "%.7z",
            "%.tar",
            "%.bz2",
            "%.epub",
            "%.flac",
            "%.tar.gz",
            -- Specific to home folder
            "~/Downloads/",
            "~/Library/",
            "~/Applications/",
            "~/.cargo",
          },
          results_title = "",
          selection_caret = "  ",
          winblend = 5,
          layout_config = {
            width = 0.90,
            height = 0.85,
            preview_cutoff = 120,
            horizontal = {
              preview_width = 0.6,
            },
            vertical = {
              width = 0.9,
              height = 0.95,
              preview_height = 0.5,
            },
            flex = {
              horizontal = {
                preview_width = 0.9,
              },
            },
          },
          mappings = {
            i = {
              ["<C-h>"] = hop.hop,
              -- ["<C-space>"] = function(prompt_bufnr)
              --   hop._hop_loop(
              --     prompt_bufnr,
              --     { callback = actions.toggle_selection, loop_callback = actions.send_selected_to_qflist }
              --   )
              -- end,
            },
          },
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
            prompt_path = true,
            grouped = true,
            files = false,
            hidden = true,
            mappings = {
              i = {
                ["<C-z>"] = fb_actions.toggle_hidden,
              },
              n = {
                z = fb_actions.toggle_hidden,
              },
            },
          },
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            mappings = { -- extend mappings
              i = {
                ["<C-a>"] = lga_actions.quote_prompt(),
                ["<C-f>"] = lga_actions.quote_prompt { postfix = " --iglob " },
              },
            },
          },
          zoxide = {
            prompt_title = "[ Let's go ]",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = function(cfg)
              local find_command = { "rg", "--files" }
              if not cfg.no_ignore then vim.list_extend(find_command, { "--glob", "!**/.git/**" }) end
              return find_command
            end,
          },
          buffers = {
            path_display = { "smart" },
            mappings = {
              i = { ["<c-d>"] = actions.delete_buffer },
              n = { ["d"] = actions.delete_buffer },
            },
          },
        },
      })
    end,
    config = function(plugin, opts)
      require "plugins.configs.telescope"(plugin, opts)
      local telescope = require "telescope"
      telescope.load_extension "live_grep_args"
      telescope.load_extension "file_browser"
      telescope.load_extension "projects"
      telescope.load_extension "noice"
      telescope.load_extension "zoxide"
    end,
  },
}
