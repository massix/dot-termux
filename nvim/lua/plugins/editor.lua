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
    opts = {
      key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
    },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wk = require("which-key")
      wk.register({
        -- Lazy Handling
        ["<leader>l"] = { name = "+lazy" },
        ["<leader>ll"] = { "<cmd>Lazy<cr>", "UI" },
        ["<leader>lh"] = { "<cmd>Lazy health<cr>", "HealthCheck" },

        ["<leader>s"] = { name = "+search" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>f"] = { name = "+file" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>u"] = { name = "+misc" },
        ["<leader>x"] = { name = "+list" },
        ["<leader>q"] = { name = "+quit" },
        ["<leader>w"] = { name = "+window" },
        ["<leader><tab>"] = { name = "+tab" },
        ["<leader>n"] = { name = "+nix" },
      })
    end,
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<leader>S"] = { name = "+spectre" },
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
      wk.register({
        ["<leader>I"] = { name = "+icons" },
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
      wk.register({
        ["gs"] = { name = "+surround" },
      })
    end,
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
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

  -- Fancy tabs and buffers
  {
    "akinsho/bufferline.nvim",
    event = { "BufEnter", "BufWinEnter" },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bC", "<CMD>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
      { "<leader>b<CR>", "<CMD>BufferLinePick<CR>", desc = "Pick buffer" },
    },
    dependencies = {
      -- buffer remove
      {
        "echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
          { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
          { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
      },
    },
    opts = function()
      return {
        highlights = require("catppuccin.groups.integrations.bufferline").get(),
        options = {
          -- stylua: ignore
          close_command = function(n) require("mini.bufremove").delete(n, false) end,
          right_mouse_command = nil,
          numbers = "ordinal",
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          separator_style = "thick",
          show_tab_indicators = true,
          color_icons = true,
          indicator = {
            icon = "▎",
            style = "icon",
          },
        },
      }
    end,
  },

  -- Dim inactive parts of code
  {
    "folke/twilight.nvim",
    lazy = false,
    opts = {
      context = 10,
      expand = {
        "function",
        "method",
        "table",
        "if_statement",
        "preproc_function_def",
        "function_definition",
        "paragraph",
        "list",
      },
    },
    keys = {
      { "<leader>zt", "<CMD>Twilight<CR>", desc = "Toggle Twilight" },
    },
  },

  -- Zen Mode editing
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 82,
        height = 1,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          cursorline = false,
          foldcolumn = "0",
        },
      },
      plugins = {
        gitsigns = { enabled = true },
        options = {
          enabled = true,
          ruler = true,
          showcmd = true,
        },
      },
    },
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<leader>z"] = { name = "+zen" },
      })
    end,
    cmd = { "ZenMode" },
    keys = {
      { "<leader>zz", "<CMD>ZenMode<CR>", desc = "Start Zen Mode" },
    },
  },

  -- Better escape
  {
    "max397574/better-escape.nvim",
    event = "BufEnter",
    opts = {
      mapping = { "jk", "jj" },
      clear_empty_lines = true,
      keys = function()
        return vim.api.nvim_win_get_cursor(0)[2] > 1 and "<esc>l" or "<esc>"
      end,
    },
    config = function(_, opts)
      require("better_escape").setup(opts)
    end,
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

  -- buffer switcher
  {
    "matbme/JABS.nvim",
    cmd = "JABSOpen",
    main = "jabs",
    opts = {
      relative = "cursor",
      border = "rounded",
      split_filename = true,
      symbols = {
        current = "󰄾",
        split = "",
        alternate = "⫝",
        hidden = "󰘓",
        locked = "",
        ro = "",
        edited = "",
        terminal = "",
        default_file = "",
        terminal_symbol = "",
      },
    },
    keys = {
      { "<leader>bj", "<cmd>JABSOpen<cr>", desc = "JABS Open" },
    },
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

      vim.api.nvim_set_keymap(
        "n",
        "<leader>cw",
        ":lua Toggle_trailspaces()<CR>",
        { noremap = true, desc = "Toggle Trailspaces" }
      )

      local group = vim.api.nvim_create_augroup("TrimWhitespaces", { clear = true })
      vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        group = group,
        pattern = "*",
        callback = function()
          if vim.g.remove_trailspaces and vim.bo.buftype == "" then
            MiniTrailspace.trim()
          end
        end,
      })
    end,
  },

  -- Autopairs
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = { "BufEnter", "BufWinEnter" },
    opts = {},
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
        codeblock_highlight = false,
      },
      org = {
        fat_headlines = false,
        codeblock_highlight = false,
      },
      norg = {
        fat_headlines = false,
        codeblock_highlight = false,
      },
    },
    ft = { "markdown", "org", "norg" },
  },

  -- Better e, w and friends
  {
    "backdround/neowords.nvim",
    event = "VeryLazy",
    config = function()
      local neowords = require("neowords")
      local p = neowords.pattern_presets
      local subword_hops = neowords.get_word_hops(
        p.snake_case,
        p.camel_case,
        p.upper_case,
        p.number,
        p.hex_color,
        "\\v:+",
        "\\v;",
        "\\v\\.+",
        "\\v,+",
        "\\v\\(+",
        "\\v\\)+",
        "\\v\\{+",
        "\\v\\}+",
        "\\v$+"
      )

      vim.keymap.set({ "n", "x", "o" }, "w", subword_hops.forward_start)
      vim.keymap.set({ "n", "x", "o" }, "e", subword_hops.forward_end)
      vim.keymap.set({ "n", "x", "o" }, "b", subword_hops.backward_start)
      vim.keymap.set({ "n", "x", "o" }, "ge", subword_hops.backward_end)
    end,
  },

  -- Legendary keybindings
  {
    "mrjones2014/legendary.nvim",
    lazy = false,
    priority = 10000,
    opts = {
      include_builtin = true,
      include_legendary_cmds = true,
      extensions = {
        lazy_nvim = true,
        which_key = {
          auto_register = true,
          do_binding = true,
          use_groups = true,
        },
      },
      scratchpad = {
        view = "float",
        results_view = "float",
        float_border = "rounded",
        keep_contents = true,
      },
    },
    keys = {
      { "<leader><space>", [[<CMD>Legendary<CR>]], desc = "Legendary" },
    },
  },

  -- Table mode for creating tables
  {
    "dhruvasagar/vim-table-mode",
    event = { "BufEnter", "BufWinEnter" },
    init = function()
      vim.g.table_mode_syntax = 0
      require("which-key").register({
        ["<leader>t"] = { name = "+table" },
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
