return {
  -- Snippet engine
  {
    "L3MON4D3/LuaSnip",
    event = "VeryLazy",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
      { "honza/vim-snippets" },
    },
    config = function(_, opts)
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
      require("luasnip").config.set_config(opts)
    end,
    opts = function()
      local types = require("luasnip.util.types")
      return {
        enable_autosnippets = true,
        history = true,
        updateevents = { "TextChanged", "TextChangedI" },
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "󱦱", "Error" } },
            },
          },
        },
      }
    end,
    keys = {
      {
        "<C-j>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end,
        mode = { "s", "i" },
      },
      {
        "<C-k>",
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
    event = { "VeryLazy" },
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-calc" },
      { "rcarriga/cmp-dap" },
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
        mapping = cmp.mapping.preset.cmdline({
          ["<C-i>"] = {
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          },
        }),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "path" },
        }),
        enabled = function()
          local disabled_commands = {
            IncRename = true,
            G = true,
            Git = true,
            ["G!"] = true,
            ["Git!"] = true,
          }

          local current_cmd = vim.fn.getcmdline():match("%S+")
          return not disabled_commands[current_cmd] or cmp.close()
        end,
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })

      -- Setup conventionalcommits for gitcommit files
      local group = vim.api.nvim_create_augroup("CmpExtra", { clear = true })
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = { "NeogitCommitMessage" },
        group = group,
        callback = function()
          if vim.g.cmp_conventionalcommits_source_id ~= nil then
            cmp.unregister_source(vim.g.cmp_conventionalcommits_source_id)
          end

          local source = require("cmp-conventionalcommits").new()

          ---@diagnostic disable-next-line: duplicate-set-field
          source.is_available = function()
            return vim.bo.filetype == "gitcommit" or vim.bo.filetype == "NeogitCommitMessage"
          end

          vim.g.cmp_conventionalcommits_source_id = cmp.register_source("conventionalcommits", source)

          cmp.setup.buffer({
            sources = cmp.config.sources({
              { name = "conventionalcommits" },
            }),
          })
        end,
      })
    end,
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local cmp_dap = require("cmp_dap")

      ---@diagnostic disable-next-line: redefined-local
      local defaults = require("cmp.config.default")()

      return {
        enabled = function()
          local disabled_fts = {
            "TelescopePrompt",
            "toggleterm",
          }

          local disabled_bts = { "prompt" }

          local ftype = vim.api.nvim_buf_get_option(0, "filetype")
          local btype = vim.api.nvim_buf_get_option(0, "buftype")
          return (not vim.tbl_contains(disabled_fts, ftype) and not vim.tbl_contains(disabled_bts, btype))
            or cmp_dap.is_dap_buffer()
        end,
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
          { name = "luasnip" },
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
        experimental = {
          ghost_text = true,
        },
      }
    end,
  },
}
