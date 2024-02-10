return {
  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo" },
    dependencies = {
      -- Similar to .vscode things
      { "folke/neoconf.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      -- Make sure we load neoconf and neodev before configuring the lsp
      require("neoconf").setup()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.clangd.setup({
        cmd = {
          "clangd",
          "--all-scopes-completion",
          "--clang-tidy",
          "--enable-config",
          "--completion-style=detailed",
        },
        capabilities = capabilities,
      })
    end,
  },

  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    keys = {
      {
        "<C-tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<C-Tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<s-tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
  },

  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-calc" },
      { "davidsierradz/cmp-conventionalcommits" },
    },
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      -- search
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
        }),
      })

      -- Setup conventionalcommits for gitcommit files
      local group = vim.api.nvim_create_augroup("CmpExtra", { clear = true })
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = { "gitcommit", "NeogitCommitMessage" },
        group = group,
        callback = function()
          require("cmp").setup.buffer({
            sources = require("cmp").config.sources({
              { name = "conventionalcommits" },
            }),
          })
        end,
      })
    end,
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")

      ---@diagnostic disable-next-line: redefined-local
      local defaults = require("cmp.config.default")()

      return {
        enabled = true,
        formatting = {
          expandable_indicator = true,
        },
        completion = {
          completeopt = "menuone,noinsert,noselect,preview",
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          docs = {
            auto_open = true,
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
          ["<S-Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "orgmode" },
          { name = "mkdnflow" },
          { name = "path" },
          { name = "emoji" },
          { name = "calc" },
        }, {
          { name = "buffer" },
        }),
        preselect = cmp.PreselectMode.None,
        sorting = defaults.sorting,
      }
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

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufEnter",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
      format_on_save = function(_)
        return { lsp_fallback = true }
      end,
      format_after_save = function(_)
        return { lsp_fallback = true, async = true }
      end,
    },
    init = function() end,
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ lsp_fallback = true })
        end,
        desc = "Format Document",
      },
    },
  },

  -- Autogenerate compile_commands.json
  {
    "leosmaia21/gcompilecommands.nvim",
    ft = { "c", "cpp" },
    opts = {
      tmp_file_path = "$HOME/tmp/compilecommandsNEOVIM.json",
    },
  },
}
