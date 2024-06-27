--- @type LazyPluginSpec[]
return {
  {
    -- FIXME: revert to upstream once https://github.com/nvim-neotest/neotest/pull/427 gets merged
    "massix/neotest",
    branch = "fix-cpu-info",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-golang")({
            go_test_args = { "-v", "-count=1" },
            dap_go_enabled = false,
          }),
        },
        output_panel = {
          open = "botright split | resize 15",
        },
        summary = {
          open = "aboveleft vsplit | vertical resize 25",
        },
        discovery = {
          concurrent = 2,
        },
      }
    end,
    config = function(_, opts)
      require("neotest").setup(opts)

      -- bind "q" to leave summary
      local group = vim.api.nvim_create_augroup("NeoTestCustom", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "neotest-summary",
        group = group,
        callback = function()
          vim.keymap.set("n", "q", function()
            require("neotest").summary.close()
          end, { desc = "Quit summary", buffer = true })
        end,
      })
    end,
    -- stylua: ignore
    keys = {
      { "<C-c>nt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File", },
      { "<C-c>nT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files", },
      { "<C-c>nr", function() require("neotest").run.run() end, desc = "Run Nearest", },
      { "<C-c>ns", function() require("neotest").summary.toggle() end, desc = "Toggle Summary", },
      { "<C-c>no", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output", },
      { "<C-c>nO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel", },
      { "<C-c>nS", function() require("neotest").run.stop() end, desc = "Stop", },
      ---@diagnostic disable-next-line: missing-fields
      { "<C-c>nd", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest", },
    },
  },
}
