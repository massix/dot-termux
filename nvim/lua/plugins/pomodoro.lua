return {
  {
    "wthollingsworth/pomodoro.nvim",
    lazy = true,
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<leader>p"] = { name = "+pomodoro" },
      })
    end,
    opts = {
      time_work = 40,
      time_break_short = 10,
      time_break_long = 20,
      timers_to_long_break = 4,
    },
    config = function(_, opts)
      require("pomodoro").setup(opts)

      -- TODO: The setup function does not work actually
      vim.g.pomodoro_time_work = opts.time_work
      vim.g.pomodoro_time_break_short = opts.time_break_short
      vim.g.pomodoro_time_break_long = opts.time_break_long
      vim.g.pomodoro_timers_to_long_break = opts.timers_to_long_break
    end,
    keys = {
      { "<leader>pp", "<CMD>PomodoroStart<CR>", desc = "Start Pomodoro" },
      { "<leader>ps", "<CMD>PomodoroStop<CR>", desc = "Stop Pomodoro" },
      { "<leader>pS", "<CMD>PomodoroStatus<CR>", desc = "Pomodoro Status" },
    },
  },
}
