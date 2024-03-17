---@type LazyPluginSpec[]
return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo" },
    dependencies = {
      -- Similar to .vscode things
      { "folke/neoconf.nvim" },
      { "folke/neodev.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "b0o/schemastore.nvim" },
      { "someone-stole-my-name/yaml-companion.nvim" },
    },
    config = function()
      require("neoconf").setup()
      require("neodev").setup()
      require("telescope").load_extension("yaml_schema")

      local lspconfig = require("lspconfig")
      local all_configs = require("lspconfig.configs")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local global_npm_path = vim.fn.expand("$HOME/../../files/usr/lib/node_modules")
      local cfg = require("yaml-companion").setup({
        lspconfig = {
          capabilities = capabilities,
          cmd = {
            "node",
            global_npm_path .. "/yaml-language-server/out/server/src/server.js",
            "--stdio",
          },
          ---@param bufnr integer
          on_attach = function(_, bufnr)
            local wk = require("which-key")
            wk.register({
              ["<leader>cS"] = { "<cmd>Telescope yaml_schema<CR>", "Switch YAML schema", { buffer = bufnr } },
            })
          end,
        },
      })

      -- Inject my own LSP
      all_configs.vscodemarkdown = {
        default_config = {
          cmd = {
            "node",
            global_npm_path .. "/vscode-langservers-extracted/lib/markdown-language-server/node/main.js",
            "--stdio",
          },
          filetypes = { "markdown" },
          root_dir = function(fname)
            local lsp_util = require("lspconfig.util")
            lsp_util.find_git_ancestor(fname)
          end,
          single_file_support = true,
        },
        docs = {
          description = "Markdown LSP used in VSCode",
          default_config = "",
        },
      }

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.clangd.setup({
        cmd = {
          "clangd",
          "--all-scopes-completion",
          "--clang-tidy",
          "--enable-config",
          "--header-insertion=iwyu",
          "--import-insertions",
          "--completion-style=detailed",
          "--background-index",
          "--pch-storage=memory",
          "--offset-encoding=utf-16",
        },
        capabilities = capabilities,
        ---@param bufnr integer
        on_attach = function(_, bufnr)
          local wk = require("which-key")
          wk.register({
            ["<leader>cS"] = {
              "<cmd>ClangdSwitchSourceHeader<cr>",
              "Switch source and headers (C/C++)",
              { buffer = bufnr, mode = "n" },
            },
          })
        end,
      })

      lspconfig.jsonls.setup({
        capabilities = capabilities,
        cmd = {
          "node",
          global_npm_path .. "/vscode-langservers-extracted/lib/json-language-server/node/jsonServerMain.js",
          "--stdio",
        },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
          jsonc = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      lspconfig.yamlls.setup(cfg)

      lspconfig.vscodemarkdown.setup({
        capabilities = capabilities,
      })

      lspconfig.bashls.setup({
        cmd = {
          "node",
          global_npm_path .. "/bash-language-server/out/cli.js",
          "start",
        },
        capabilities = capabilities,
      })

      lspconfig.typst_lsp.setup({
        capabilities = capabilities,
      })
    end,
  },

  -- LSP Interactions
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    opts = {
      hover = {
        open_cmd = "!xdg-open",
      },
      code_action = {
        show_server_name = true,
        extend_gitsigns = false,
      },
      lightbulb = {
        virtual_text = true,
      },
      outline = {
        win_position = "left",
        close_after_jump = true,
        auto_preview = false,
      },
      finder = {
        default = "ref+def+impl",
      },
      ui = {
        border = "single",
      },
    },
    keys = {
      -- Leader prefixed
      { "<leader>cpD", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
      { "<leader>cgD", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto definition" },
      { "<leader>cpd", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek type definition" },
      { "<leader>cgd", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Goto type definition" },

      { "<leader>cf", "<cmd>Lspsaga finder<cr>", desc = "See references/implementations" },
      { "<leader>ch", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover" },
      { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code action" },
      { "<leader>cr", "<cmd>Lspsaga rename<cr>", desc = "LSP Rename" },

      -- goto things
      { "gpD", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek definition" },
      { "gD", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto definition" },
      { "gpd", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek type definition" },
      { "gd", "<cmd>Lspsaga goto_type_definition<cr>", desc = "Goto type definition" },

      -- Misc
      { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover" },

      -- Diagnostics
      { "<leader>cdp", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Previous diagnostic" },
      { "<leader>cdn", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next diagnostic" },
      { "<leader>cdw", "<cmd>Lspsaga show_workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>cdb", "<cmd>Lspsaga show_buf_diagnostics<cr>", desc = "Buffer diagnostics" },
      { "<leader>cdl", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Line diagnostics" },
      { "<leader>cdc", "<cmd>Lspsaga show_cursor_diagnostics<cr>", desc = "Line diagnostics" },
    },
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<leader>c"] = { name = "+code" },
        ["<leader>cd"] = { name = "+diagnostics" },
        ["<leader>cp"] = { name = "+peek" },
        ["<leader>cg"] = { name = "+goto" },
        ["gp"] = { name = "+peek" },
      })
    end,
  },
}
