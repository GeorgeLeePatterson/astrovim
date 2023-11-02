local utils = require "user.utils"

local rust_config = function()
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
      on_initialized = function()
        -- vim.cmd [[
        --   augroup RustLSP
        --     autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
        --     autocmd InsertEnter                     *.rs silent! lua vim.lsp.buf.clear_references()
        --     autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
        --   augroup END
        -- ]]
      end,
      inlay_hints = {
        auto = true,
        highlight = "LspInlayHint",
      },
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

  -- [[ Tools]]

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
    opts = rust_config,
    config = rust_tools_setup,
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
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    },
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- rust_analyzer = rust_analyzer_config(),
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
      setup = {
        -- rust_analyzer = rust_tools_setup,
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
