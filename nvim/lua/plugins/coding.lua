return {
  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {},
    event = { "LspAttach" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
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
        go = { "gofumpt" },
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
    "ThePrimeagen/refactoring.nvim",
    opts = {},
    config = false,
    event = "BufEnter",
  },

  {
    "mfussenegger/nvim-lint",
    opts = {},
    config = function()
      require("lint").linters_by_ft = {
        c = { "cppcheck" },
        cpp = { "cppcheck" },
        fish = { "fish" },
        go = { "golangcilint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
