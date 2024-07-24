return {
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
}
