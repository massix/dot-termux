return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    name = "tokyonight",
    priority = 10000,
    opts = {
      style = "moon",
      transparent = false,
      terminal_colors = true,
      hide_inactive_statusline = true,
      dim_inactive = true,
      lualine_bold = true,
      styles = {
        floats = "dark",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
    end,
  },

  {
    "catppuccin/nvim",
    lazy = false,
    priority = 10000,
    name = "catppuccin",
    enabled = true,
    opts = {
      flavour = "mocha",
      term_colors = true,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.10,
      },
      no_italic = true,
      show_end_of_buffer = false,
      transparent_background = false, -- does not make sense in termux
      integrations = {
        alpha = false,
        mini = {
          enabled = true,
          indentscope_color = "mauve",
        },
        neotest = true,
        rainbow_delimiters = true,
        overseer = true,
        ufo = true,
        cmp = true,
        neogit = true,
        noice = true,
        notify = true,
        window_picker = false,
        which_key = true,
        treesitter = true,
        flash = true,
        gitsigns = true,
        headlines = false,
        markdown = true,
        telescope = {
          enabled = true,
        },
        indent_blankline = {
          enabled = true,
          scope_color = "mauve",
          colored_indent_levels = true,
        },
      },
    },
  },

  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 10000,
    enabled = true,
    opts = {
      style = "vulgaris",
    },
    config = function(_, opts)
      require("bamboo").setup(opts)
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 10000,
    enabled = true,
  },

  {
    "baliestri/aura-theme",
    lazy = false,
    priority = 10000,
    enabled = true,
    opts = {},
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
    end,
  },

  {
    "savq/melange-nvim",
    lazy = false,
    priority = 10000,
    enabled = true,
    config = false,
  },

  {
    "luisiacc/gruvbox-baby",
    lazy = false,
    priority = 10000,
    enabled = true,
    config = false,
  },

  {
    "rafamadriz/neon",
    lazy = false,
    priority = 10000,
    enabled = true,
    init = function()
      vim.o.termguicolors = true
      vim.g.neon_style = "doom"
      vim.g.neon_bold = true
    end,
    config = false,
  },

  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 10000,
    enabled = true,
    config = false,
  },
}
