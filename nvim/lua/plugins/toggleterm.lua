--- @type LazyPluginSpec[]
return {
  {
    "akinsho/toggleterm.nvim",
    dependencies = {
      {
        "chomosuke/term-edit.nvim",
        ft = { "toggleterm" },
        version = "1.*",
        opts = {
          prompt_end = { "❯ ", "%$ ", "> " },
          mapping = {
            n = {
              i = "<C-i>",
            },
          },
        },
      },
    },
    version = "*",
    opts = {
      float_opts = { border = "single", title_pos = "left" },
      winbar = { enabled = false },
      open_mapping = false,
      insert_mappings = false,
      shade_terminals = true,
      autochdir = true,
      close_on_exit = true,
    },
    cmd = { "ToggleTerm" },
    init = function()
      local wk = require("which-key")
      wk.add({
        { "<c-c>t", group = "+terminal" },
        { "<C-\\>", group = "terminal" },
      })

      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        group = vim.api.nvim_create_augroup("ToggleTermHandler", { clear = true }),
        callback = function()
          vim.opt_local.spell = false
        end,
      })
    end,
    keys = function()
      local starter = {
        {
          "<C-c>tt",
          [[<cmd>execute v:count . "ToggleTerm direction=horizontal"<cr>]],
          desc = "Toggle default terminal",
          silent = true,
        },
        {
          "<C-`>",
          [[<cmd>execute v:count . "ToggleTerm direction=horizontal"<cr>]],
          desc = "Toggle default terminal",
          silent = true,
        },
        {
          "<C-\\><C-\\>",
          [[<cmd>execute v:count . "ToggleTerm direction=horizontal"<cr>]],
          desc = "Toggle default terminal",
          silent = true,
        },
      }

      ---@param prefix string
      local create_keys = function(prefix)
        return {
          {
            prefix .. "f",
            [[<cmd>execute v:count . "ToggleTerm direction=float"<cr>]],
            desc = "Toggle floating terminal",
            silent = true,
          },
          { prefix .. "a", [[<cmd>ToggleTermToggleAll<cr>]], desc = "toggle all terminals", silent = true },
          { prefix .. "s", [[<cmd>TermSelect<cr>]], desc = "select terminal", silent = true },
          {
            prefix .. "s",
            [[<cmd>execute "ToggleTermSendCurrentLine ". v:count<cr>]],
            desc = "Send current line to terminal",
          },
          {
            prefix .. "s",
            [[<cmd>execute "ToggleTermSendVisualSelection " . v:count<cr>]],
            mode = { "v" },
            desc = "Send visual selection to terminal",
          },
        }
      end

      for _, v in ipairs(create_keys("<C-\\>")) do
        table.insert(starter, v)
      end

      for _, v in ipairs(create_keys("<C-c>t")) do
        table.insert(starter, v)
      end

      return starter
    end,
  },
}
