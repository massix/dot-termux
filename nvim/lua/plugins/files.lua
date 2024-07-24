---@type LazyPluginSpec[]
return {
  -- mini.files is an excellent netrw replacement and file browser
  {
    "echasnovski/mini.files",
    lazy = false,
    event = "VeryLazy",
    opts = {
      windows = {
        preview = true,
        width_preview = 35,
        width_focus = 35,
        width_nofocus = 15,
      },
      options = {
        use_as_default_explorer = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>fm", function() MiniFiles.open() end, desc = "mini.files", },
    },
  },

  -- Oil
  {
    "stevearc/oil.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "SirZenith/oil-vcs-status" },
    },
    cmd = { "Oil" },
    opts = {
      default_file_explorer = false,
      constrain_cursor = "editable",
      experimental_watch_for_changes = true,
      columns = {
        "icon",
        "permissions",
      },
      win_options = {
        signcolumn = "number",
      },
      keymaps = {
        q = "actions.close",
      },
    },
    keys = {
      { "<leader>fo", "<cmd>Oil<cr>", desc = "Oil" },
      { "<leader>ff", "<cmd>Oil --float<cr>", desc = "Oil (float)" },
    },
  },
}
