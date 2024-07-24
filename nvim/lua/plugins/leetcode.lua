-- Play with leetcode from neovim!

--- @type LazyPluginSpec[]
return {
  {
    "kawre/leetcode.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lang = "golang",
      injector = {
        ["golang"] = {
          before = { "package main" },
        },
      },
      plugins = {
        non_standalone = true,
      },
    },
    config = function(_, opts)
      require("leetcode").setup(opts)
    end,
    cmd = { "Leet" },
  },
}
