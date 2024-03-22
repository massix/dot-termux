local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic options
require("config.options")

require("lazy").setup({
  spec = { import = "plugins" },

  -- All plugins are lazy by default
  defaults = {
    lazy = true,
    version = false,
  },

  ui = {
    border = "double",
  },

  -- Install a colorscheme
  install = {
    colorscheme = { "catppuccin" },
  },

  -- Enable checker for updating plugins
  checker = {
    enabled = true,
    notify = false,
  },

  -- Disable some problematic native plugins of nvim
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Keymaps
require("config.keymaps")

-- Sometimes I connect via SSH using Neovide from PC
_G.neovide_config = function()
  if vim.g.neovide then
    vim.notify("Neovide detected, applying config", vim.log.levels.INFO)
    vim.g.neovide_hide_mouse_when_typing = false

    local function scale(delta)
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
    end

    -- stylua: ignore
    vim.keymap.set("n", "<C-->", function() scale(-0.10) end, { desc = "Decrease scale factor" })

    -- stylua: ignore
    vim.keymap.set("n", "<C-=>", function() scale(0.10) end, { desc = "Increase scale factor" })

    -- stylua: ignore
    vim.keymap.set("n", "<C-0>", function() vim.g.neovide_scale_factor = 1.0 end, { desc = "Reset scale factor" })
  else
    vim.notify("Not in Neovide, not applying config", vim.log.levels.WARN)
  end
end

local all_rhs = { "<C-->", "<C-=>", "<C-0>" }
for _, rhs in ipairs(all_rhs) do
  -- stylua: ignore
  vim.keymap.set("n", rhs, function() _G.neovide_config() end, { desc = "Only works in neovide" })
end

-- Autoreload buffer when the file is modified
local group = vim.api.nvim_create_augroup("AutoReload", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  group = group,
  callback = function()
    if vim.api.nvim_get_mode().mode ~= "c" then
      vim.cmd.checktime()
    end
  end,
})

-- Close some windows with q
vim.api.nvim_create_autocmd("Filetype", {
  group = vim.api.nvim_create_augroup("CloseWithQ", { clear = true }),
  pattern = {
    "fugitive",
    "git",
    "help",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "qf",
    "aerial-nav",
    "dap-float",
  },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
  end,
})

vim.cmd([[colorscheme catppuccin]])
