local utils = require "user.utils"

local rust_opts = function()
  local adapter

  local success, package = pcall(
    function() return require("mason-registry").get_package "codelldb" end
  )
  if success then
    local package_path = package:get_install_path()
    local codelldb_path = package_path .. "/codelldb"
    local liblldb_path = package_path .. "/extension/lldb/lib/liblldb"
    local this_os = vim.loop.os_uname().sysname

    -- The path in windows is different
    if this_os:find "Windows" then
      codelldb_path = package_path .. "\\extension\\adapter\\codelldb.exe"
      liblldb_path = package_path .. "\\extension\\lldb\\bin\\liblldb.dll"
    else
      -- The liblldb extension is .so for linux and .dylib for macOS
      liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
    end
    adapter = require("rust-tools.dap").get_codelldb_adapter(
      codelldb_path,
      liblldb_path
    )
  else
    ---@diagnostic disable-next-line: missing-parameter
    adapter = require("rust-tools.dap").get_codelldb_adapter()
  end

  local server = require("astronvim.utils.lsp").config "rust_analyzer"

  return {
    server = server,
    dap = { adapter = adapter },
    tools = {
      inlay_hints = {
        auto = true,
        highlight = "LspInlayHint",
      },
      on_initialized = function()
        vim.api.nvim_create_autocmd(
          { "BufWritePost", "BufEnter", "InsertLeave" },
          {
            pattern = { "*.rs" },
            callback = function() vim.lsp.codelens.refresh() end,
          }
        )
      end,
    },
  }
end

local rust_tools_setup = function(_, opts)
  require("rust-tools").setup(opts)

  -- Keymaps
  vim.keymap.set(
    { "n" },
    "<leader>a",
    "<cmd>RustCodeAction<cr>",
    { desc = "🦀 Rust code [a]ctions" }
  )
  vim.keymap.set(
    { "n" },
    "K",
    "<cmd>RustHoverActions<cr>",
    { desc = "🦀 Hover Actions (Rust)" }
  )
  vim.keymap.set(
    { "n" },
    "<leader>dr",
    "<cmd>RustDebuggables<cr>",
    { desc = "🦀 Run Debuggables (Rust)" }
  )
end

return {
  -- [[ Treesitter ]]
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed =
          utils.list_insert_unique(opts.ensure_installed, {
            "rust",
            "toml",
          })
      end
      return opts
    end,
  },

  -- [[ LSP ]

  -- Mason-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
        "rust_analyzer",
        "taplo",
      })
      return opts
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed =
        utils.list_insert_unique(opts.ensure_installed, "codelldb")
      return opts
    end,
  },

  -- Rust-tools
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = function(_, opts)
          opts.ensure_installed =
            utils.list_insert_unique(opts.ensure_installed, "codelldb")
          return opts
        end,
      },
    },
    ft = { "rust" },
    init = function()
      astronvim.lsp.skip_setup =
        utils.list_insert_unique(astronvim.lsp.skip_setup, "rust_analyzer")
    end,
    opts = rust_opts,
    config = rust_tools_setup,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        taplo = {
          keys = {
            {
              "K",
              function()
                if
                  vim.fn.expand "%:t" == "Cargo.toml"
                  and require("crates").popup_available()
                then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
    },
  },

  -- Crates
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    init = function()
      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          ---@diagnostic disable-next-line: missing-fields
          require("cmp").setup.buffer { sources = { { name = "crates" } } }
          require "crates"
        end,
      })
    end,
    opts = {
      src = { cmp = { enabled = true } },
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    },
  },

  -- [[ Linting / Formatting ]]

  -- Nvim-lint
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft, {
        rust = { "clippy" },
      })
      return opts
    end,
  },
}
