return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      lazygit = { enabled = true },
      quickfile = { enabled = true },
      terminal = { enable = true },
    },
  }
}
