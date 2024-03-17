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
              vim.notify(err .. "", vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- yaml and json ls companion
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = { "VeryLazy" },
    config = false,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = "BufEnter",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        c = { "clang_format" },
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

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "ThePrimeagen/refactoring.nvim",
    },
    name = "null-ls",
    opts = {},
    config = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          nls.builtins.diagnostics.cppcheck,
          nls.builtins.diagnostics.fish,
          nls.builtins.code_actions.refactoring,
        },
      })
    end,
    event = { "BufEnter", "BufWinEnter" },
  },
}
