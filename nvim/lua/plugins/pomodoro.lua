return {
  {
    "dbinagi/nomodoro",
    lazy = true,
    cmd = {
      "NomoWork",
      "NomoTimer",
      "NomoBreak",
      "NomoMenu",
    },
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<leader>p"] = { name = "+pomodoro" },
      })
    end,
    opts = {
      work_time = 40,
      short_break_time = 10,
      long_break_time = 20,
      break_cycle = 4,
      menu_available = true,
      texts = {
        on_break_complete = "TIME IS UP!",
        on_work_complete = "TIME IS UP!",
        status_icon = " ",
        timer_format = "!%0M:%0S",
      },
      on_work_complete = function()
        vim.notify("Take a break")
      end,
      on_break_complete = function()
        vim.notify("Go back to work")
      end,
    },
    keys = {
      { "<leader>p<cr>", [[<cmd>NomoWork<cr>]], desc = "Pomodoro Work" },
      { "<leader>ps", [[<cmd>NomoStop<cr>]], desc = "Pomodoro Stop" },
      { "<leader>pb", [[<cmd>NomoBreak<cr>]], desc = "Pomodoro Break" },
      { "<leader>pp", [[<cmd>NomoMenu<cr>]], desc = "Pomodoro Menu" },
    },
  },
}
