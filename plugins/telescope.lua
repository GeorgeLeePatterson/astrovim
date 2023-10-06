local R = function(name) return require(name) end

if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

return {
  "jvgrootveld/telescope-zoxide",
  "rcarriga/nvim-notify",
  "nvim-lua/plenary.nvim",
  {
    "tiagovla/scope.nvim",
    lazy = false,
    config = function(_, opts) require("scope").setup(opts) end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-hop.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jay-babu/project.nvim",
      "jvgrootveld/telescope-zoxide",
      { "tiagovla/scope.nvim" },
    },
    opts = function(_, opts)
      local actions = require "telescope.actions"
      local fb_actions = require("telescope").extensions.file_browser.actions
      local lga_actions = require "telescope-live-grep-args.actions"
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
          scroll_strategy = "limit",
          layout_config = {
            width = 0.90,
            height = 0.85,
            preview_cutoff = 5,
            horizontal = {
              preview_width = 0.6,
              prompt_position = "bottom",
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
              ["<C-h>"] = R("telescope").extensions.hop.hop,
              ["<C-space>"] = function(prompt_bufnr)
                require("telescope").extensions.hop._hop_loop(
                  prompt_bufnr,
                  { callback = actions.toggle_selection, loop_callback = actions.send_selected_to_qflist }
                )
              end,
            },
          },
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
            prompt_path = true,
            grouped = true,
            files = false,
            hidden = { file_browser = true, folder_browser = false },
            depth = 2,
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
          colorscheme = {
            enable_preview = true,
            theme = "ivy",
          },
          buffers = {
            theme = "dropdown",
            path_display = { "smart" },
            mappings = {
              i = { ["<c-d>"] = actions.delete_buffer },
              n = { ["d"] = actions.delete_buffer },
            },
          },
          find_files = {
            theme = "ivy",
            hidden = true,
            find_command = function(cfg)
              local find_command = { "rg", "--files" }
              if not cfg.no_ignore then vim.list_extend(find_command, { "--glob", "!**/.git/**" }) end
              return find_command
            end,
          },
          lsp_references = {
            theme = "cursor",
            initial_mode = "normal",
            prompt_title = false,
          },
          notify = {
            layout_strategy = "vertical",
          },
          zoxide = {
            theme = "ivy",
            initial_mode = "normal",
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
      telescope.load_extension "scope"
    end,
  },
}
