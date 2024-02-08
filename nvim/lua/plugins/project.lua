return {
  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    event = "VeryLazy",
    opts = {
      detection_methods = { "pattern" },
      patterns = {
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        "index.org",
        "compile_flags.txt",
        "compile_commands.json",
      },
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = "global",
      datapath = vim.fn.stdpath("data"),
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },
}
