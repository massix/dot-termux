local fg = function(name)
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

--- @type LazyPluginSpec[]
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {},
    opts = function()
      return {
        options = {
          theme = "catppuccin",
          globalstatus = false,
          icons_enabled = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                local convert = {
                  ["normal"] = "N",
                  ["insert"] = "I",
                  ["visual"] = "VV",
                  ["v-line"] = "VL",
                  ["v-block"] = "VB",
                  ["command"] = "C",
                  ["terminal"] = "T",
                  ["replace"] = "R",
                }

                if vim.g.venn_enabled then
                  return "VNN"
                ---@diagnostic disable-next-line: undefined-field
                elseif vim.b.table_mode_active == 1 then
                  return "TBL"
                end

                return convert[str:lower()]
              end,
            },
            {
              function()
                local ok, m = pcall(require, "better_escape")
                return ok and m.waiting and "✺" or ""
              end,
              cond = function()
                return package.loaded["better_escape"] and require("better_escape").waiting ~= nil
              end,
            },
          },
          lualine_b = {
            { "branch" },
            {
              function()
                ---@param headline OrgHeadline
                ---@return string
                local generate_statusline = function(headline)
                  local effort = headline:get_property("effort")
                  local active = headline:get_logbook():get_total_with_active():to_string()

                  ---@type string
                  local result

                  if effort then
                    result = string.format("%s/%s", active, effort)
                  else
                    result = string.format("%s", active)
                  end

                  return result
                end

                local orgmode = require("orgmode").instance()
                local clocked_headline = orgmode.clock.clocked_headline

                if clocked_headline then
                  return generate_statusline(clocked_headline)
                else
                  return ""
                end
              end,
              cond = function()
                if package.loaded["orgmode"] then
                  local orgmode = require("orgmode").instance()
                  return orgmode and orgmode.clock:has_clocked_headline()
                else
                  return false
                end
              end,
              icon = " ",
              color = function()
                if not package.loaded["orgmode"] then
                  return nil
                end

                local clocked_headline = require("orgmode").instance().clock.clocked_headline
                local priority = clocked_headline and clocked_headline:get_priority()
                local highlights = {
                  A = { fg = "#f38ba8", gui = "bold" },
                  B = { fg = "#f9e2af", gui = "bold" },
                  C = { fg = "#a6e3e1", gui = "bold" },
                }

                return highlights[priority] or highlights.B
              end,
            },
            {
              function()
                local msg = "No LSP"
                local bufnr = vim.api.nvim_get_current_buf()
                local bufft = vim.api.nvim_buf_get_option(bufnr, "filetype")
                local clients = {}

                -- FIXME: rewrite this
                for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
                  table.insert(clients, client)
                end

                if next(clients) == nil then
                  return msg
                end

                for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, bufft) ~= -1 then
                    local ret = " "
                    if #clients > 1 then
                      ret = ret .. "+"
                    end
                    return ret
                  end
                end
                return msg
              end,
              cond = function()
                local bufnr = vim.api.nvim_get_current_buf()
                local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
                return next(clients) ~= nil
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
            {
              "overseer",
              colored = true,
              unique = true,
            },
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
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          -- stylua: ignore
          lualine_z = {
            {
              function() return require("nomodoro").status() end,
              cond = function()
                return package.loaded["nomodoro"] and require("nomodoro").status() ~= nil
              end,
            },
            { function() return " " .. os.date("%R") end, },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { "filetype", separator = "", icon_only = true },
            { "filename", path = 0, shorting_target = 30 },
          },
          lualine_x = {},
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {},
        },
        tabline = {
          lualine_a = {
            {
              "buffers",
              show_filename_only = true,
              mode = 4,
              use_mode_colors = false,
              filetype_names = {
                oil = "Oil",
                lazy = "Lazy",
                minifiles = "MiniFiles",
                OverseerList = "Overseer",
              },
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {
            { require("lazy.status").updates, cond = require("lazy.status").has_updates },
          },
          lualine_y = {
            {
              function()
                return require("termux").get_battery_statusline()
              end,
            },
          },
          lualine_z = {
            { "tabs" },
          },
        },
        extensions = { "lazy", "trouble" },
      }
    end,
  },
}
