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
        use_as_default_explorer = false,
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
      {
        "SirZenith/oil-vcs-status",
        config = function()
          local status_const = require("oil-vcs-status.constant.status")
          local StatusType = status_const.StatusType
          require("oil-vcs-status").setup({
            status_symbol = {
              [StatusType.Added] = "",
              [StatusType.Copied] = "󰆏",
              [StatusType.Deleted] = "",
              [StatusType.Ignored] = "",
              [StatusType.Modified] = "",
              [StatusType.Renamed] = "",
              [StatusType.TypeChanged] = "󰉺",
              [StatusType.Unmodified] = " ",
              [StatusType.Unmerged] = "",
              [StatusType.Untracked] = "",
              [StatusType.External] = "",
              [StatusType.UpstreamAdded] = "󰈞",
              [StatusType.UpstreamCopied] = "󰈢",
              [StatusType.UpstreamDeleted] = "",
              [StatusType.UpstreamIgnored] = " ",
              [StatusType.UpstreamModified] = "󰏫",
              [StatusType.UpstreamRenamed] = "",
              [StatusType.UpstreamTypeChanged] = "󱧶",
              [StatusType.UpstreamUnmodified] = " ",
              [StatusType.UpstreamUnmerged] = "",
              [StatusType.UpstreamUntracked] = " ",
              [StatusType.UpstreamExternal] = "",
            },
          })
        end,
      },
    },
    event = "VeryLazy",
    opts = {
      default_file_explorer = true,
      constrain_cursor = "editable",
      watch_for_changes = true,
      skip_confirm_for_simple_edits = true,
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      win_options = {
        signcolumn = "yes:2",
      },
      keymaps = {
        q = "actions.close",
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)
      local group = vim.api.nvim_create_augroup("OilAutoCmd", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType", "BufWritePost" }, {
        group = group,
        pattern = "oil",
        callback = function(args)
          vim.api.nvim_buf_set_var(args.buf, "modifiable", true)
        end,
      })
    end,
    keys = {
      { "<leader>fo", "<cmd>Oil<cr>", desc = "Oil" },
      { "<leader>ff", "<cmd>Oil --float<cr>", desc = "Oil (float)" },
    },
  },
}
