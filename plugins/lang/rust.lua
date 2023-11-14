local utils = require "user.utils"
local lsp_utils = require "user.utils.lsp"
local autocmd_buf = require("user.utils.autocmds").create_buffer_keymap

local keymap = vim.keymap.set

local rust_setup = function(bufnr)
  -- Refresh inlay hints
  pcall(function() vim.lsp.inlay_hint(bufnr, true) end)

  -- Keymaps
  keymap(
    { "n", "v" },
    "<leader>a",
    function() vim.cmd.RustLsp { "hover", "actions" } end,
    { desc = "🦀 Rust [a]ctions", buffer = bufnr }
  )
  keymap(
    { "n", "v" },
    "<leader>le",
    function() vim.cmd.RustLsp "explainError" end,
    { desc = "🦀 Explain Errors (Rust)", buffer = bufnr }
  )
end

local setup_dap = function()
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
    return { codelldb_path, liblldb_path }
  end
  return
end

vim.g.rustaceanvim = function()
  local server = require("astronvim.utils.lsp").config "rust_analyzer"

  -- Configure on_attach
  local on_attach = server["on_attach"]
  server["on_attach"] = function(client, bufnr)
    if on_attach then pcall(function() on_attach(client, bufnr) end) end
    rust_setup(bufnr)
  end

  -- Configure capabilities
  server["capabilities"] = lsp_utils.capabilities(server["capabilities"])

  -- COnfigure dap
  local adapter
  local ok, dap = pcall(require, "rustaceanvim.dap")
  if ok then
    local dap_paths = setup_dap() or {}
    adapter = dap.get_codelldb_adapter(dap_paths[1], dap_paths[2])
  end

  return {
    server = server,
    dap = { adapter = adapter },
    tools = {
      autoSetHints = true,
      inlay_hints = {
        auto = true,
        highlight = "LspInlayHint",
        show_parameter_hints = true,
      },
      on_initialized = function()
        -- Autocommand to refresh codelens
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
  -- {
  --   "simrat39/rust-tools.nvim",
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     "nvim-lua/plenary.nvim",
  --     {
  --       "jay-babu/mason-nvim-dap.nvim",
  --       opts = function(_, opts)
  --         opts.ensure_installed =
  --           utils.list_insert_unique(opts.ensure_installed, "codelldb")
  --         return opts
  --       end,
  --     },
  --   },
  --   ft = { "rust" },
  --   init = function()
  --     astronvim.lsp.skip_setup =
  --       utils.list_insert_unique(astronvim.lsp.sip_setup, "rust_analyzer")
  --   end,
  --   opts = rust_opts,
  --   config = rust_tools_setup,
  -- },
  {
    "mrcjkb/rustaceanvim",
    version = "^3", -- Recommended
    ft = { "rust" },
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
      autocmd_buf("CmpSourceCargo", { "BufRead" }, "Cargo.toml", {
        {
          mode = { "n", "v" },
          lhs = "<leader>lu",
          rhs = function() require("crates").upgrade_crate() end,
          opts = { desc = "🦀 Update crate" },
        },
        {
          mode = { "n", "v" },
          lhs = "<leader>lU",
          rhs = function() require("crates").upgrade_all_crates() end,
          opts = { desc = "🦀 Update all crates" },
        },
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
