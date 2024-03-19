-- Debug adapters for NeoVim
local json_transforms = {
  ["lldb"] = { "c", "cpp" },
}

--- @type LazyPluginSpec[]
return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<C-c>d"] = { name = "+debug" },
        ["<C-c>da"] = { name = "+adapters" },
      })
    end,

    dependencies = {
      -- fancy UI for the debugger
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          { "nvim-neotest/nvim-nio" },
        },
        -- stylua: ignore
        keys = {
          ---@diagnostic disable-next-line: missing-fields
          { "<C-c>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },

          ---@diagnostic disable-next-line: missing-fields
          { "<C-c>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
        },
        opts = {
          layouts = {
            {
              elements = {
                "repl",
                "console",
              },
              size = 20,
              position = "bottom",
            },
            {
              elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
              },
              size = 50,
              position = "right",
            },
          },
        },
      },

      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },

    --- @type any[]
    -- stylua: ignore
    keys = {
      { "<C-c>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<C-c>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<C-c>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<C-c>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<C-c>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<C-c>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<C-c>dj", function() require("dap").down() end, desc = "Down" },
      { "<C-c>dk", function() require("dap").up() end, desc = "Up" },
      { "<C-c>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<C-c>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<C-c>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<C-c>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<C-c>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<C-c>ds", function() require("dap").session() end, desc = "Session" },
      { "<C-c>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<C-c>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      { "<C-c>dJ", function() require("dap.ext.vscode").load_launchjs(nil, json_transforms) end, desc = "Load Launch JSON" },
    },

    opts = {},
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      local dap = require("dap")

      require("dap.ext.vscode").json_decode = require("overseer.json").decode
      require("overseer").patch_dap(true)

      for name, sign in pairs(require("utils.defaults").icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      dap.adapters.lldb = {
        type = "executable",
        command = "/data/data/com.termux/files/usr/bin/lldb-vscode",
        name = "lldb",
      }

      -- setup dap config by VsCode launch.json file
      require("dap.ext.vscode").load_launchjs(nil, json_transforms)
    end,
  },
}
