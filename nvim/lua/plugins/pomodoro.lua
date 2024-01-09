return {
  {
    "dbinagi/nomodoro",
    lazy = true,
    cmd = { "NomoWork", "NomoTimer", "NomoBreak" },
    init = function()
      local wk = require("which-key")
      wk.register({
        [ "<leader>p" ] = { name = "+pomodoro" },
      })
    end,
    opts = {
      work_time = 40,
      break_time = 10,
    },
    keys = {
      { "<leader>pp", [[<cmd>NomoWork<cr>]], desc = "Pomodoro Work" },
      { "<leader>ps", [[<cmd>NomoStop<cr>]], desc = "Pomodoro Stop" },
      { "<leader>pb", [[<cmd>NomoBreak<cr>]], desc = "Pomodoro Break" },
    },
  },
}
