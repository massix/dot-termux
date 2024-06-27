return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", config = false },
      {
        "IndianBoy42/tree-sitter-just",
        lazy = false,
        config = false,
      },
    },
    cmd = { "TSUpdateSync" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      highlight = {
        enable = true,
      },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "cpp",
        "dhall",
        "dockerfile",
        "elvish",
        "fish",
        "go",
        "haskell",
        "hjson",
        "html",
        "ini",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "just",
        "kdl",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "nix",
        "norg",
        "purescript",
        "query",
        "racket",
        "regex",
        "rust",
        "terraform",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      require("tree-sitter-just").setup({})
      require("nvim-treesitter.configs").setup(opts)

      -- Once treesitter loaded, we can change the foldmethod
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
}
