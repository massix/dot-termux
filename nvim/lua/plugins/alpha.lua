return {
  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      -- stylua: ignore
      -- luacheck: ignore
      local logo = [[
                                        ,e,               ,d8 8b,    e88",8,  
        888 888 8e   ,"Y88b  dP"Y  dP"Y  "       Y8b Y8Y  "Y8 8P"   d888  "   
        888 888 88b "8" 888 C88b  C88b  888       Y8b Y   ,d8 8b,  C8888 88e  
        888 888 888 ,ee 888  Y88D  Y88D 888      e Y8b   C888 888D  Y888 888D 
        888 888 888 "88 888 d,dP  d,dP  888     d8b Y8b   "Y8 8P"    "88 88"  
                                            888                               
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      -- stylua: ignore
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<CMD> Telescope find_files<CR>"),
        dashboard.button("e", " " .. " Open org", [[<CMD> cd ~/org <BAR> e ./index.org<CR>]]),
        dashboard.button("L", "󰒲 " .. " Lazy", "<CMD> Lazy<CR>"),
        dashboard.button("h", " " .. " Project", "<CMD>Telescope projects<CR>"),
        dashboard.button("e", " " .. " Org Index", "<CMD> cd ~/org <BAR> e ./index.org<CR>"),
        dashboard.button("m", " " .. " Agenda", [[<CMD> lua require("orgmode.api.agenda").agenda({ span = 5 })<CR>]]),
        dashboard.button("w", " " .. " Work agenda", [[<CMD> lua require("orgmode.api.agenda").agenda({ span = 5, filters = "+work" })<CR>]]),
        dashboard.button("W", " " .. " Personal agenda", [[<CMD> lua require("orgmode.api.agenda").agenda({ span = 5, filters = "+personal" })<CR>]]),
        dashboard.button("l", "✓ " .. " Todos", [[<CMD> lua require("orgmode.api.agenda").todos()<CR>]]),
        dashboard.button("t", " " .. " Work todos", [[<CMD> lua require("orgmode.api.agenda").todos( { filters = "+work" })<CR>]]),
        dashboard.button("T", " " .. " Personal todos", [[<CMD> lua require("orgmode.api.agenda").todos( { filters = "+personal" })<CR>]]),
        dashboard.button("q", " " .. " Quit", "<CMD> qa<CR>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      return dashboard
    end,

    config = function(_, dashboard)
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          dashboard.section.footer.val = "NeoVim started in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
    keys = {
      { "<leader>A", "<cmd>Alpha<cr>", desc = "Open Alpha" },
    },
  },
}
