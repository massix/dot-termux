-- Here all the plugins for the editor
return {

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      render = "default",
      stages = "slide",
      top_down = true,
    },
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
      preset = "helix",
      triggers = {
        { "<auto>", mode = "nxsot" },
        { "<C-c>", mode = "i" },
      },
      spec = {
        { "<leader>l", group = "lazy" },
        { "<leader>ll", "<cmd>Lazy<cr>", desc = "UI" },
        { "<leader>lh", "<cmd>Lazy health<cr>", desc = "HealthCheck" },
        { "<leader>s", group = "search" },
        { "<leader>g", group = "git" },
        { "<leader>f", group = "file" },
        { "<leader>b", group = "buffer" },
        { "<leader>u", group = "misc" },
        { "<leader>x", group = "list" },
        { "<leader>q", group = "quit" },
        { "<leader>w", group = "window" },
        { "<leader><tab>", group = "tab" },
      },
    },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>S", group = "spectre" },
      })
    end,
    opts = {
      open_cmd = "noswapfile vnew",
      live_update = true,
      is_open_target_win = true,
      is_insert_mode = true,
      is_block_ui_break = true,
    },
    -- stylua: ignore
    keys = {
      { "<leader>So", function() require("spectre").toggle() end, desc = "Toggle Spectre" },
      { "<leader>Sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search current word", mode = "v" },
      { "<leader>Sw", function() require("spectre").open_visual() end, desc = "Search current word", mode = "n" },
      { "<leader>Sp", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Search on current file" },
    },
  },

  -- Jump around!
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          enable = false,
        },
      },
    },
  -- stylua: ignore
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Icon Picker
  {
    "ziontee113/icon-picker.nvim",
    cmd = { "IconPickerNormal", "IconPickerYank", "IconPickerInsert" },
    opts = {
      disable_legacy_commands = true,
    },
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<leader>I", group = "+icons" },
      })
    end,
    keys = {
      { "<leader>Ii", "<cmd>IconPickerNormal<cr>", desc = "Icon Picker" },
      { "<C-c>i", mode = "i", "<cmd>IconPickerInsert<cr>", desc = "Icon Picker" },
    },
  },

  -- Better MatchParen
  {
    "utilyre/sentiment.nvim",
    lazy = false,
    config = true,
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },

  -- Surround motion
  {
    "echasnovski/mini.surround",
    lazy = false,
    version = "*",
    config = true,
    init = function()
      local wk = require("which-key")
      wk.add({
        { "gs", group = "+surround" },
      })
    end,
    opts = {
      -- stylua: ignore
      mappings = {
        add = "gsa",            -- Add surrounding in Normal and Visual modes
        delete = "gsd",         -- Delete surrounding
        find = "gsf",           -- Find surrounding (to the right)
        find_left = "gsF",      -- Find surrounding (to the left)
        highlight = "gsh",      -- Highlight surrounding
        replace = "gsr",        -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },

  -- Comments
  { "numToStr/Comment.nvim", lazy = false, config = true },

  -- highlights TODO and similar comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
  },

  -- Better escape
  {
    "max397574/better-escape.nvim",
    event = "BufEnter",
    opts = {
      mappings = {
        i = {
          j = {
            j = "<esc>",
            k = "<esc>",
          },
        },
      },
    },
  },

  -- Code outline and navigation
  {
    "stevearc/aerial.nvim",
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = {
        default_direction = "prefer_left",
        placement = "edge",
      },

      highlight_on_hover = true,
      show_guides = true,
    },
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>co", "<cmd>AerialToggle<cr>", desc = "Open outline" },
      { "<leader>cn", "<cmd>AerialNavToggle<cr>", desc = "Open float outline" },
    },
  },

  -- Highlight ranges
  {
    "winston0410/range-highlight.nvim",
    dependencies = { "winston0410/cmd-parser.nvim" },
    event = { "BufEnter", "BufWinEnter" },
    opts = {},
  },

  -- Better tab scoping
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Trailspaces and stuff
  {
    "echasnovski/mini.trailspace",
    version = "*",
    event = { "BufEnter", "BufWinEnter" },
    opts = {
      only_in_normal_buffers = true,
    },
    config = function(_, opts)
      require("mini.trailspace").setup(opts)
      vim.g.remove_trailspaces = true

      function _G.Toggle_trailspaces()
        if vim.g.remove_trailspaces then
          vim.notify("Disabling automatic trim of whitespaces")
          vim.g.remove_trailspaces = false
        else
          vim.notify("Enabling automatic trim of whitespaces")
          vim.g.remove_trailspaces = true
        end
      end

      require("which-key").add({
        {
          "<leader>cw",
          function()
            vim.g.remove_trailspaces = not vim.g.remove_trailspaces
            vim.notify("Trailspaces: " .. (vim.g.remove_trailspaces and "enabled" or "disabled"), vim.log.levels.INFO)
          end,
          noremap = true,
          desc = "Toggle Trailspaces",
        },
      })

      local group = vim.api.nvim_create_augroup("TrimWhitespaces", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        pattern = "*",
        callback = function()
          local ignored_filetypes = {
            "oil",
            "taskedit",
            "term",
            "alpha",
          }

          if
            vim.g.remove_trailspaces
            and vim.bo.buftype == ""
            and not vim.tbl_contains(ignored_filetypes, vim.bo.filetype)
          then
            MiniTrailspace.trim()
          end
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "taskedit",
        group = group,
        callback = function() end,
      })
    end,
  },

  -- Move selection
  {
    "echasnovski/mini.move",
    version = "*",
    event = { "BufEnter", "BufWinEnter" },
    opts = {},
  },

  -- Better headlines
  {
    "lukas-reineke/headlines.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      markdown = {
        fat_headlines = false,
        codeblock_highlight = true,
      },
      org = {
        fat_headlines = false,
        codeblock_highlight = true,
      },
      norg = {
        fat_headlines = false,
        codeblock_highlight = true,
      },
    },
    ft = { "markdown", "org", "norg" },
  },

  -- Better w, e, b and friends
  {
    "chrisgrieser/nvim-spider",
    event = { "BufEnter" },
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = true,
        subwordMovement = true,
        customPatterns = {},
      })

      local map_spider = function(key)
        vim.keymap.set({ "x", "n", "o" }, key, [[<cmd>lua require("spider").motion("]] .. key .. [[")<cr>]])
      end

      map_spider("w")
      map_spider("e")
      map_spider("b")
      map_spider("ge")
    end,
  },

  -- Table mode for creating tables
  {
    "dhruvasagar/vim-table-mode",
    event = { "BufEnter", "BufWinEnter" },
    init = function()
      vim.g.table_mode_syntax = 0
      require("which-key").add({
        { "<leader>t", group = "+table" },
      })
    end,
    config = false,
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    dependencies = {
      "junegunn/fzf",
    },
    opts = {},
    ft = { "qf" },
  },

  -- Align easily
  {
    "echasnovski/mini.align",
    opts = {},
    keys = {
      { "ga", mode = { "n", "v" }, desc = "Align" },
      { "gA", mode = { "n", "v" }, desc = "Align with preview" },
    },
  },
}
