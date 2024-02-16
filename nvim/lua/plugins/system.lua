return {
  {
    "massix/termux.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    event = "VimEnter",
    opts = {
      volume = {
        streams = { "music", "ring" },
      },
    },
  },
}
