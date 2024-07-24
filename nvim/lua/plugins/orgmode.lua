--- @type LazyPluginSpec[]
return {

  -- orgmode
  {
    "nvim-orgmode/orgmode",
    ft = { "org", "orgagenda" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", lazy = true },
      {
        "nvim-orgmode/telescope-orgmode.nvim",
        version = "1.1.0",
        config = function()
          require("telescope").load_extension("orgmode")
        end,
        keys = {
          { "<leader>sO", "<cmd>Telescope orgmode search_headings<CR>", desc = "Search org headings" },
        },
      },
      { "danilshvalov/org-modern.nvim", config = false },
      {
        "nvim-orgmode/org-bullets.nvim",
        opts = {},
      },
      {
        "massix/org-checkbox.nvim",
        opts = {},
        main = "orgcheckbox",
      },
      {
        "chipsenkbeil/org-roam.nvim",
        opts = {
          directory = "~/org/roam",
          bindings = { prefix = "<leader>on" },
          database = {
            persist = true,
            update_on_save = true,
          },
        },
        init = function()
          require("which-key").add({
            { "<leader>on", group = "roam" },
            { "<leader>ond", group = "daily" },
          })
        end,
        config = function(_, opts)
          require("org-roam").setup(opts)
          require("which-key").add({
            { "<leader>onA", group = "alias" },
            { "<leader>ond", group = "daily" },
            { "<leader>ono", group = "origin" },
          })

          local group = vim.api.nvim_create_augroup("OrgRoam", { clear = true })
          vim.api.nvim_create_autocmd({ "FileType" }, {
            group = group,
            pattern = "org",
            callback = function(args)
              local roam = require("org-roam")
              local wk = require("which-key")

              local prefix = "<C-c>n"

              wk.add({
                {
                  mode = "i",
                  buffer = args.buf,
                  { prefix, group = "roam" },
                  { prefix .. ".", roam.api.complete_node, desc = "Complete node" },
                  { prefix .. "i", roam.api.insert_node, desc = "Insert node" },
                  {
                    prefix .. "m",
                    function()
                      roam.api.insert_node({ immediate = true })
                    end,
                    desc = "Insert node (immediate)",
                  },
                },
              })
            end,
          })
        end,
        keys = {
          {
            "<leader>onf",
            function()
              require("org-roam").api.find_node()
            end,
            desc = "Find node",
          },
          {
            "<leader>ondn",
            function()
              require("org-roam").ext.dailies.goto_today()
            end,
            desc = "Open today's note",
          },
          {
            "<leader>ondy",
            function()
              require("org-roam").ext.dailies.goto_yesterday()
            end,
            desc = "Open yesterday's note",
          },
          {
            "<leader>ondt",
            function()
              require("org-roam").ext.dailies.goto_tomorrow()
            end,
            desc = "Open tomorrow's note",
          },
          {
            "<leader>ondd",
            function()
              require("org-roam").ext.dailies.goto_date()
            end,
            desc = "Open date chooser",
          },
        },
      },
    },
    config = function(_, opts)
      local orgmode = require("orgmode")
      orgmode.setup(opts)

      local orgmode_group = vim.api.nvim_create_augroup("OrgMode", { clear = true })

      -- Set conceal stuff automatically when in org files
      vim.api.nvim_create_autocmd("Filetype", {
        group = orgmode_group,
        pattern = "org",
        callback = function(args)
          vim.wo.concealcursor = "vnic"
          vim.wo.conceallevel = 3

          -- Make sure we only advance one step at a time
          vim.opt_local.tabstop = 1
          vim.opt_local.shiftwidth = 1

          -- Enable modeline for org buffers
          vim.opt_local.modeline = true
          vim.opt_local.modelines = 30

          -- Allow the cursor to go one char beyond EOL
          vim.opt_local.virtualedit = "onemore"

          require("which-key").add({
            {
              buffer = args.buf,
              {
                "<C-c>c",
                function()
                  if vim.wo.conceallevel > 0 then
                    vim.wo.conceallevel = 0
                    vim.notify("Conceal off", vim.log.levels.INFO)
                  else
                    vim.wo.conceallevel = 3
                    vim.notify("Conceal on", vim.log.levels.INFO)
                  end
                end,
                desc = "Toggle conceal",
                mode = { "n", "i", "v" },
              },
              {
                "<C-c><CR>",
                function()
                  require("orgmode").action("org_mappings.meta_return")
                end,
                mode = "i",
                desc = "Org Meta Return",
                silent = true,
              },
            },
          })
        end,
      })
    end,
    opts = function()
      local Menu = require("org-modern.menu")
      return {
        ui = {
          menu = {
            handler = function(data)
              local org = require("orgmode").instance()

              local custom_items = {
                {
                  label = "Agenda for current week",
                  key = "a",
                  action = function()
                    org.agenda:agenda({
                      span = "week",
                    })
                  end,
                },
                {
                  label = "Agenda for Today",
                  key = "d",
                  action = function()
                    org.agenda:agenda({
                      span = "day",
                    })
                  end,
                },
                {
                  label = "Personal To-Do",
                  key = "p",
                  action = function()
                    org.agenda:tags({
                      todo_only = true,
                      search = "+personal-project-recurring-habit/-MEET-WAITING",
                    })
                  end,
                },
                {
                  label = "Personal Projects",
                  key = "P",
                  action = function()
                    org.agenda:tags({
                      todo_only = true,
                      search = "+personal+project-recurring-habit/-MEET-WAITING",
                    })
                  end,
                },
                {
                  label = "Work To-Do",
                  key = "w",
                  action = function()
                    org.agenda:tags({
                      todo_only = true,
                      search = "+work-project-recurring-habit/-MEET-WAITING",
                    })
                  end,
                },
                {
                  label = "Work Projects",
                  key = "W",
                  action = function()
                    org.agenda:tags({
                      todo_only = true,
                      search = "+work+project-recurring-habit/-MEET-WAITING",
                    })
                  end,
                },
                {
                  label = "Search for To-Dos",
                  key = "s",
                  action = function()
                    org.agenda:tags({
                      todo_only = true,
                    })
                  end,
                },
                {
                  label = "Search all headings",
                  key = "S",
                  action = function()
                    org.agenda:tags()
                  end,
                },
              }

              Menu:new({ window = { margin = { 1, 1, 1, 1 } } }):open({
                prompt = data.prompt,
                title = data.title,
                items = data.title == "Select a capture template" and data.items or custom_items,
              })
            end,
          },
        },
        org_agenda_files = {
          "~/org/*.org",
          "~/org/roam/*.org",
          "~/org/roam/daily/*.org",
        },
        org_todo_keywords = {
          "TODO(t)",
          "NEXT(n)",
          "PROGRESS(p)",
          "WAITING(w)",
          "MEET(m)",
          "|",
          "DONE(d)",
          "CANCELLED(c)",
          "DELEGATED(l)",
        },
        org_default_notes_file = "~/org/refile.org",
        org_agenda_text_search_extra_files = { "agenda-archives" },
        org_startup_indented = true, -- only for nightly
        org_adapt_indentation = false,
        org_tags_column = -80,
        win_split_mode = "bot 20sp",
        win_border = "rounded",
        calendar_week_start_day = 1,
        org_agenda_start_day = 1,
        org_hide_leading_stars = false,
        org_hide_emphasis_markers = false,
        org_log_into_drawer = "LOGBOOK",
        org_startup_folded = "content",
        org_id_uuid_program = "uuidgen",
        org_id_link_to_org_use_id = true,
        org_edit_src_content_indentation = 2,
        org_capture_templates = {
          r = {
            description = "Refilable Task",
            template = "* TODO %?\n  %u",
            headline = "Tasks",
            target = "~/org/refile.org",
          },
          t = {
            description = "Personal Task",
            template = "* TODO %?\n  %u",
            headline = "Tasks",
            target = "~/org/index.org",
          },
          T = {
            description = "Work Task",
            template = "* TODO %?\n  %u",
            headline = "Tasks",
            target = "~/org/work.org",
          },
          c = {
            description = "Personal calendar entry",
            template = "* MEET %?\n  SCHEDULED: %^{Meeting Date}T",
            headline = "Calendar",
            target = "~/org/index.org",
          },
          C = {
            description = "Work calendar entry",
            template = "* MEET %?\n  SCHEDULED: %^{Meeting Date}T",
            headline = "Calendar",
            target = "~/org/work.org",
          },
        },
        mappings = {
          org = {
            org_toggle_checkbox = "<C-p>",
          },
          capture = {
            org_capture_finalize = "<C-c>O<CR>",
            org_capture_kill = { "<C-c>Ok", "q" },
            org_capture_refile = "<C-c>Or",
          },
          note = {
            org_note_finalize = "<C-c>O<CR>",
            org_note_kill = { "<C-c>Ok", "q" },
          },
        },
        notifications = {
          enabled = true,
          cron_enabled = false,
          reminder_time = { 0, 5, 10, 15 },
        },
        org_todo_keyword_faces = {
          WAITING = ":foreground #ffee93",
          MEET = ":foreground #fce1e4 :weight bold :underline on",
          NEXT = ":foreground #d4afb9",
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>oR", function() require("orgmode").instance().clock:init() end, desc = "org reset clock" },
      { "<leader>oa", function() require("orgmode").action("agenda.prompt") end, desc = "org agenda" },
      { "<leader>oc", function() require("orgmode").action("capture.prompt") end, desc = "org capture" },
    },
  },

  -- Draw diagrams
  {
    "jbyuki/venn.nvim",
    lazy = false,
    event = "VeryLazy",
    config = function()
      vim.g.venn_enabled = false

      -- Create a function in the global namespace
      -- FIXME: probably not the best solution
      function _G.Toggle_Venn()
        if vim.g.venn_enabled == false then
          vim.notify("Enabling Venn mode")
          vim.g.venn_enabled = true

          vim.opt_local.virtualedit = "all"
          vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
        else
          vim.notify("Disabling Venn mode")
          vim.g.venn_enabled = false

          vim.opt_local.virtualedit = "none"
          vim.api.nvim_buf_del_keymap(0, "n", "J")
          vim.api.nvim_buf_del_keymap(0, "n", "H")
          vim.api.nvim_buf_del_keymap(0, "n", "K")
          vim.api.nvim_buf_del_keymap(0, "n", "L")
          vim.api.nvim_buf_del_keymap(0, "v", "f")
        end
      end

      -- stylua: ignore
      vim.api.nvim_set_keymap( "n", "<leader>Iv", ":lua Toggle_Venn()<CR>", { noremap = true, desc = "Toggle Venn Mode" })
    end,
  },
}
