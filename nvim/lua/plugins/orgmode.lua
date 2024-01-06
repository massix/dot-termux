return {
  {
    "nvim-orgmode/orgmode",
    enabled = true,
    lazy = false,
    dependencies = {
      { "akinsho/org-bullets.nvim", config = true, lazy = false },
      { "lukas-reineke/headlines.nvim", config = true, lazy = false },
      { "nvim-treesitter/nvim-treesitter", lazy = true, },
      { "joaomsa/telescope-orgmode.nvim", lazy = false, }
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("orgmode").setup_ts_grammar()
      require("orgmode").setup(opts)

      -- Disable column in orgagenda
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = { "orgagenda" },
        callback = function()
          vim.opt_local.foldcolumn = "0"
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
    end,
    opts = {
      org_agenda_files = {
        "~/org/**/*.org",
      },
      org_todo_keywords = {
        "TODO(t)",
        "NEXT(n)",
        "PROGRESS(p)",
        "WAITING(w)",
        "|",
        "DONE(d)",
        "CANCELLED(c)",
        "DELEGATED(D)",
      },
      org_default_notes_file = "~/org/refile.org",
      org_indent_mode = "virtual_indent",
      org_tags_column = 0,
      win_split_mode = "horizontal",
      win_border = "rounded",
      org_hide_leading_stars = true,
      org_hide_emphasis_markers = true,
      org_log_into_drawer = "LOGBOOK",
      org_startup_folded = "content",
      org_capture_templates = {
        t = {
          description = "Task",
          template = "* TODO %?\n%u",
          headline = "Tasks",
          target = "~/org/refile.org",
        },
        r = {
          description = "Note",
          template = "* %?\n%u",
          headline = "Notes",
          target = "~/org/refile.org",
        },
        m = {
          description = "Meeting minutes",
          template = "* %<%Y-%m-%d> %?\n%u\n** Participants\n** Topics",
          headline = "Meetings",
          target = "~/org/work.org",
        },
      },
      ui = {
        virtual_indent = {
          handler = nil,
        },
      },
      mappings = {
        org = {
          org_toggle_checkbox = "<C-p>",
        },
      },
    },
  },
}
