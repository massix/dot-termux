return {
  {
    "nvim-neorg/neorg",
    ft = "norg",
    cmd = "Neorg",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.itero"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              default_workspace = "private",
              private = "~/neorg",
            },
            index = "index.norg",
          },
        },
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<leader>",
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
      },
    },
  },
}
