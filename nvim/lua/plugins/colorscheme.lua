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
        percentage = 0.30,
      },
      integrations = {
        mini = true,
        neotest = true,
        notify = true,
        window_picker = true,
        lsp_trouble = true,
        which_key = true,
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
