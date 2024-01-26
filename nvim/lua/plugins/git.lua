return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      { "sindrets/diffview.nvim", lazy = false, },
      { "ibhagwan/fzf-lua", lazy = false, },
    },
    opts = {
      disable_hint = false,
      disable_signs = false,
      disable_line_numbers = false,
      console_timeout = 15000,
      status = {
        recent_commit_count = 50,
      },
      graph_style = "unicode",
      signs = {
        hunk = { "", "" },
        item = { " ", " " },
        section = { " ", " " },
      },
      integrations = {
        telescope = true,
        diffview = true,
      },
    },

    -- stylua: ignore
    keys = {
      {
        "<leader>gg",
        function() require("neogit").open() end,
        desc = "Open Neogit",
      },
      {
        "<leader>gC",
        function() require("neogit").open({ "commit" }) end,
        desc = "Open Neogit commit",
      },
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>gB",
        "<cmd>Gitsigns toggle_current_line_blame<cr>",
        desc = "Toggle Git blame"
      },
    },
  },
}
