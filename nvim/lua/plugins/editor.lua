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
    version = false,
    lazy = false,
    event = "VeryLazy",
    opts = {
      windows = {
        preview = true,
        width_preview = 30,
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
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },

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
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- Jump around!
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  -- stylua: ignore
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
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
    version = false,
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

  -- completion engine
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
    },
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      -- cmdline
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
          { { name = "buffer" } },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")

      ---@diagnostic disable-next-line: redefined-local
      local defaults = require("cmp.config.default")()

      return {
        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          docs_auto_open = true,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
          ["<S-Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        }),
        sources = cmp.config.sources({
          { name = "orgmode" },
          { name = "path" },
          { name = "buffer" },
        }),
        preselect = cmp.PreselectMode.None,
        sorting = defaults.sorting,
      }
    end,
  },

  -- Fancy tabs and buffers
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
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
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        right_mouse_command = nil,
        numbers = "ordinal",
        always_show_bufferline = false,
        separator_style = "thick",
        show_tab_indicators = true,
        color_icons = true,
        indicator = {
          icon = "▎",
          style = "icon",
        },
      },
    },
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
      on_events = { "InsertLeave", "CursorHoldI" },
      max_length = 4,
      trim_by_words = true,
      default_config = {
        prefix_string = " ",
      },
      language_config = {
        org = { disabled = true },
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
}
