local api = vim.api

return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    config = true,
    opts = {
      console_timeout = 15000,
      status = {
        recent_commit_count = 50,
      },
    },

    keys = {
      {
        "<leader>gg",
        function()
          require("neogit").open()
        end,
        desc = "Open Neogit",
      },
      {
        "<leader>gC",
        function()
          require("neogit").open({ "commit" })
        end,
        desc = "Open Neogit commit",
      },
    },
  },

  -- Git blame info
  {
    "f-person/git-blame.nvim",
    version = false,
    config = true,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>gB", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git blame" },
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    version = false,
    config = true,
    event = { "BufReadPre", "BufNewFile" },
  },

}
