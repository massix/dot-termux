return {
  {
    "stevearc/overseer.nvim",
    opts = {
      dap = false,
    },
    event = "VeryLazy",
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<C-c>o", group = "overseer" },
        { "<C-c>oT", group = "toggle" },
      })
    end,
    keys = {
      { "<C-c>or", "<cmd>OverseerRun<cr>", desc = "Run Overseer" },
      { "<C-c>ot", "<cmd>OverseerToggle left<cr>", desc = "Toggle Overseer" },
      { "<C-c>oq", "<cmd>OverseerQuickAction<cr>", desc = "Overseer Quick Action" },
      { "<C-c>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer Build" },
      { "<C-c>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer Build" },
      { "<C-c>oTl", "<CMD>OverseerToggle left<cr>", desc = "Toggle left" },
      { "<C-c>oTr", "<CMD>OverseerToggle right<cr>", desc = "Toggle right" },
      { "<C-c>oTb", "<CMD>OverseerToggle bottom<cr>", desc = "Toggle bottom" },
    },
  },
}
