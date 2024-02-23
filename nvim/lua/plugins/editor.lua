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
    keys = {
      {
        "<leader>fo",
        function()
          MiniFiles.open()
        end,
        desc = "File Browser",
      },
    },
  },

  -- Oil
  {
    "stevearc/oil.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "SirZenith/oil-vcs-status" },
    },
    event = "VeryLazy",
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<leader>fm"] = { name = "+oil" },
      })
    end,
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
    },
    keys = {
      { "<leader>fmo", "<cmd>Oil<cr>", desc = "Oil" },
      { "<leader>fmf", "<cmd>Oil --float<cr>", desc = "Oil (float)" },
    },
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    cmd = "Telescope",
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("orgmode")
      require("telescope").load_extension("projects")
    end,
    opts = function()
      -- change default theme
      return {
        defaults = vim.tbl_extend("force", require("telescope.themes").get_dropdown(), {
          prompt_prefix = " ",
          selection_caret = " ",
        }),
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>.", "<cmd>Telescope find_files<cr>", desc = "Open file" },
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },

      -- find
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },

      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
      { "<leader>gS", "<cmd>Telescope git_status<CR>", desc = "status" },

      -- search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sO", "<cmd>Telescope orgmode search_headings<cr>", desc = "Org Headings" },
      { "<leader>sp", "<cmd>Telescope projects<cr>", desc = "Change project" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
    },
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
      { "<C-i>", mode = "i", "<cmd>IconPickerInsert<cr>", desc = "Icon Picker (insert)" },
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

  -- Better folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufEnter",
    opts = {
      open_fold_hl_timeout = 150,
      close_fold_kinds = { "imports", "comment" },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-b>",
          scrollD = "<C-f>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      require("ufo").setup(opts)

      vim.opt.foldenable = true
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldcolumn = "0"
    end,
    -- stylua: ignore
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds", },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds", },
      { "zp", function() require('ufo').peekFoldedLinesUnderCursor() end, desc = "Preview fold", },
    },
  },

  -- Dim inactive parts of code
  {
    "folke/twilight.nvim",
    lazy = false,
    opts = {
      context = 2,
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
    commands = { "ZenMode" },
    keys = {
      { "<leader>zz", "<CMD>ZenMode<CR>", desc = "Start Zen Mode" },
    },
  },

  -- Code biscuits
  {
    "code-biscuits/nvim-biscuits",
    event = "BufEnter",
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<leader>c"] = { name = "+code" },
      })
    end,
    opts = {
      show_on_start = false,
      cursor_line_only = true,
      on_events = { "CursorHoldI", "InsertLeave" },
      trim_by_words = false,
      default_config = {
        prefix_string = " ",
      },
      language_config = {
        org = { disabled = true },
        markdown = { disabled = true },
      },
    },
    keys = {
      {
        "<leader>cb",
        function()
          require("nvim-biscuits").toggle_biscuits()
        end,
        desc = "Toggle biscuits",
      },
    },
  },

  -- Better escape
  {
    "max397574/better-escape.nvim",
    event = "BufEnter",
    opts = {
      mapping = { "jk", "jj", "kj" },
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

  -- Confirm before leaving Neovim
  {
    "yutkat/confirm-quit.nvim",
    event = "CmdlineEnter",
    opts = {
      overwrite_q_command = false,
      quit_message = "U sure?",
    },
    config = function(_, opts)
      require("confirm-quit").setup(opts)
      vim.cmd([[
        function! s:solely_in_cmd(command)
          return (getcmdtype() == ':' && getcmdline() ==# a:command)
        endfunction

        cnoreabbrev <expr> q <SID>solely_in_cmd('q') ? 'ConfirmQuit' : 'q'
        cnoreabbrev <expr> qa <SID>solely_in_cmd('qa') ? 'ConfirmQuitAll' : 'qa'
        cnoreabbrev <expr> qq <SID>solely_in_cmd('qq') ? 'quit' : 'qq'
        cnoreabbrev <expr> wq <SID>solely_in_cmd('wq') ? 'w <bar> ConfirmQuit' : 'wq'
        cnoreabbrev <expr> wqa <SID>solely_in_cmd('wqa') ? 'wall <bar> ConfirmQuitAll' : 'wqa'
      ]])
    end,
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

  -- Arrow for bookmarks
  {
    "otavioschwanck/arrow.nvim",
    event = "VeryLazy",
    opts = {
      show_icons = true,
      leader_key = ";",
    },
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
}
