local options = function(opts)
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
          function(win)
            return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
              ~= "TelescopeResults"
          end,
        },
      },
      action = function(match)
        local picker =
          require("telescope.actions.state").get_current_picker(prompt_bufnr)
        picker:set_selection(match.pos[1] - 1)
      end,
    }
  end

  return vim.tbl_deep_extend("force", opts, {
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
      -- open files in the first window that is an actual file.
      -- use the current window if no other window is available.
      get_selection_window = function()
        local wins = vim.api.nvim_list_wins()
        table.insert(wins, 1, vim.api.nvim_get_current_win())
        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "" then return win end
        end
        return 0
      end,
      results_title = "",
      selection_caret = "  ",
      winblend = 5,
      sorting_strategy = "descending",
      layout_strategy = "vertical",
      layout_config = {
        preview_cutoff = 5,
        horizontal = {
          preview_width = 0.6,
          prompt_position = "bottom",
        },
        vertical = { preview_height = 0.5 },
        flex = {
          flip_columns = 200,
        },
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
        grouped = true,
        hidden = { file_browser = true, folder_browser = false },
        prompt_path = true,
        depth = 2,
        mappings = {
          i = { ["<C-z>"] = function() pcall(fb_actions.toggle_hidden) end },
          n = { z = function() pcall(fb_actions.toggle_hidden) end },
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
        prompt_title = "[ Z Files ]",
        initial_mode = "normal",
      },
    },
    pickers = {
      colorscheme = {
        enable_preview = true,
        theme = "ivy",
      },
      buffers = {
        theme = "dropdown",
        initial_mode = "normal",
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
          if not cfg.no_ignore then
            vim.list_extend(find_command, { "--glob", "!**/.git/**" })
          end
          return find_command
        end,
      },
      -- Find words
      grep_string = {
        layout_strategy = "flex",
      },
      live_grep = {
        layout_strategy = "flex",
      },
      lsp_references = {
        theme = "cursor",
        initial_mode = "normal",
        prompt_title = false,
      },
      oldfiles = {
        theme = "ivy",
      },
    },
  })
end

return function(plugin, opts)
  opts = options(opts)
  require "plugins.configs.telescope"(plugin, opts)
  local telescope = require "telescope"
  telescope.load_extension "live_grep_args"
  telescope.load_extension "file_browser"
  telescope.load_extension "noice"
  telescope.load_extension "zoxide"
  telescope.load_extension "scope"
end
