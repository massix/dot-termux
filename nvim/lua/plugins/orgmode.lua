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
    end,
    opts = {
      org_agenda_files = { "~/org/**/*" },
      org_todo_keywords = { "TODO(t)", "NEXT(n)", "PROGRESS(p)", "|", "DONE(d)", "NOTVALID(i)" },
      org_default_notes_file = "~/org/refile.org",
      org_indent_mode = "virtual_indent",
      win_split_mode = "horizontal",
      win_border = "rounded",
      org_hide_leading_stars = true,
      org_hide_emphasis_markers = true,
      org_log_into_drawer = "LOGBOOK",
      org_startup_folded = "inherit",
      org_capture_templates = {
        t = {
          description = "Task",
          template = "* TODO %?\n%u",
        },
        r = {
          description = "Random note",
          template = "* %?\n%u",
        },
      },
      ui = {
        virtual_indent = {
          handler = nil,
        },
      },
    },
  },

  {
    "nvim-neorg/neorg",
    lazy = false,
    enabled = false,
    event = "VeryLazy",
    build = ":Neorg sync-parsers",
    dependencies = {
      "laher/neorg-exec",
    },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.journal"] = {
          config = {
            strategy = "flat",
            workspace = "norg",
          },
        },
        ["core.esupports.metagen"] = {
          config = {
            type = "auto",
            update_date = true,
          },
        },
        ["core.ui.calendar"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              norg = "~/norg",
            },
            index = "index.norg",
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.looking-glass"] = {},
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<Leader>o",
            hook = function(keybinds)
              -- :Neorg keybind all core.looking-glass.magnify-code-block
              keybinds.remap_event("norg", "n", "<C-c>o", "core.looking-glass.magnify-code-block")
            end,
          },
        },
        ["core.qol.toc"] = {},
        ["core.qol.todo_items"] = {},
        ["core.export"] = {},
        ["core.export.markdown"] = {
          config = {
            extensions = "all",
          },
        },
        ["core.summary"] = {},
        ["core.integrations.treesitter"] = {},
        ["core.integrations.nvim-cmp"] = {},
        ["external.exec"] = {},
      },
    },
  },
}
