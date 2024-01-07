function fg(name)
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

local git_icons = {
  added = " ",
  modified = " ",
  removed = " ",
}

return {
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "seoul256",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
          icons_enabled = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch" },
            {
              -- FIXME: this can be done in a better way probably
              function()
                ---@diagnostic disable-next-line: undefined-global
                local clock = orgmode.statusline()
                if clock ~= nil and clock ~= "" then
                  local final = clock:gsub("%(Org%)", " "):gsub("%%", "%%%%"):gsub("%((.*)%)", "%1")
                  return final
                else
                  return ""
                end
              end,
            },
          },
          lualine_c = {
            { "diagnostics" },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 1 } },
            {
              "filename",
              path = 1,
              --- @param str string
              fmt = function(str)
                --- @type string
                local fn = vim.fn.expand("%:~:.")

                if vim.startswith(fn, "jdt://") then
                  return fn:gsub("?.*$", "")
                end
                return str
              end,
            },
          },
          lualine_x = {
            { require("lazy.status").updates, cond = require("lazy.status").has_updates },
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = fg("Constant"),
            },
            {
              "diff",
              symbols = {
                added = git_icons.added,
                modified = git_icons.modified,
                removed = git_icons.removed,
              },
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          -- stylua: ignore
          lualine_z = {
            {
              function() return require("pomodoro").statusline() end,
              cond = function()
                return package.loaded["pomodoro"] and require("pomodoro").statusline() ~= nil
              end,
            },
            { function() return " " .. os.date("%R") end, },
          },
        },
        extensions = { "nvim-tree", "lazy", "trouble" },
      }
    end,
  },
}
