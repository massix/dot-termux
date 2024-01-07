return {
  {
    "stevearc/overseer.nvim",
    opts = {},
    lazy = false,
    event = "VeryLazy",
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<C-c>o"] = { name = "+overseer" },
      })
    end,
    keys = {
      { "<C-c>ot", [[<cmd>OverseerToggle<cr>]], desc = "Toggle Overseer" },
      { "<C-c>or", [[<cmd>OverseerRun<cr>]], desc = "Run Overseer" },
    },
  },
}
