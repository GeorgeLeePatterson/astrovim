return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "jvgrootveld/telescope-zoxide",
      { "tiagovla/scope.nvim" },
    },
    opts = function(_, opts)
      local actions = require "telescope.actions"
      local fb_actions = require("telescope").extensions.file_browser.actions
      local lga_actions = require "telescope-live-grep-args.actions"
      local mappings = (opts.defaults or {}).mappings or {}

      -- Use the awesome flash to move around
      local function flash(prompt_bufnr)
        if not require("astronvim.utils").is_available "flash.nvim" then return end
        require("flash").jump {
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults" end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        }
      end

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
          sorting_strategy = "descending",
          layout_config = {
            preview_cutoff = 5,
            horizontal = {
              preview_width = 0.6,
              prompt_position = "bottom",
            },
            vertical = { preview_height = 0.5 },
            flex = { horizontal = { preview_width = 0.9 } },
          },
          mappings = vim.tbl_deep_extend("force", mappings, {
            n = { s = flash },
            i = { ["<c-s>"] = flash },
          }),
          -- Removes spacing before matches in result pane
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim", -- add this value
          },
        },
        extensions = {
          file_browser = {
            hijack_netrw = true,
            prompt_path = true,
            grouped = true,
            hidden = { file_browser = true, folder_browser = false },
            depth = 2,
            mappings = {
              i = { ["<C-z>"] = function() fb_actions.toggle_hidden() end },
              n = { z = function() fb_actions.toggle_hidden() end },
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
          file_browser = {
            theme = "center",
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
      -- telescope.load_extension "projects"
      telescope.load_extension "noice"
      telescope.load_extension "zoxide"
      telescope.load_extension "scope"
    end,
  },
}
