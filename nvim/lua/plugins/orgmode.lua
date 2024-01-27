return {

  -- orgmode
  {
    "nvim-orgmode/orgmode",
    enabled = true,
    lazy = false,
    dependencies = {
      { "akinsho/org-bullets.nvim", config = true, lazy = false },
      { "nvim-treesitter/nvim-treesitter", lazy = true },
      { "joaomsa/telescope-orgmode.nvim", lazy = false },
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
          vim.opt_local.signcolumn = "no"
        end,
      })
    end,
    opts = {
      org_agenda_files = {
        "~/org/*.org",
      },
      org_todo_keywords = {
        "TODO(t)",
        "NEXT(n)",
        "PROGRESS(p)",
        "WAITING(w)",
        "|",
        "DONE(d)",
        "CANCELLED(c)",
        "DELEGATED(l)",
      },
      org_default_notes_file = "~/org/refile.org",
      org_agenda_text_search_extra_files = { "agenda-archives" },
      org_startup_indented = true,
      org_adapt_indentation = false,
      org_tags_column = 0,
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
      mappings = {
        org = {
          org_toggle_checkbox = "<C-p>",
          org_forward_heading_same_level = "<leader>]",
          org_backward_heading_same_level = "<leader>[",
        },
      },
    },
  },

  -- markdown navigation for 2nd brain
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    lazy = true,
    opts = {
      modules = {
        cmp = true,
      },
      wrap = true,
      links = {
        style = "markdown",
        transform_explicit = function(text)
          text = text:gsub(" ", "-")
          text = text:lower()
          return text
        end,
      },
      new_file_template = {
        use_template = true,
        template = "# {{ title }}"
      },
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
