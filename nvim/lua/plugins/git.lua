return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      { "sindrets/diffview.nvim", lazy = false },
      { "ibhagwan/fzf-lua", lazy = false },
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
        item = { " ", " " },
        section = { " ", " " },
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
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<leader>g"] = { mode = "v", name = "+git" },
      })
    end,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>gB",
        "<cmd>Gitsigns toggle_current_line_blame<cr>",
        desc = "Toggle Git blame",
      },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
      { "<leader>gP", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Preview Hunk (inline)" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk", mode = { "n", "v" } },
      { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo stage Hunk", mode = { "n", "v" } },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk", mode = { "n", "v" } },
    },
  },

  -- Easily copy shareable links for different platforms
  {
    "linrongbin16/gitlinker.nvim",
    cmd = { "GitLink" },
    opts = {},
  },
}
