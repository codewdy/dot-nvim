return {
  {
    "folke/trouble.nvim",
    event = "LspAttach",
    opts = {
      modes = {
        symbols = {
          auto_open = true,
          auto_close = true,
          focus = false,
          follow = true,
          win = {
            position = "right",
            size = 0.3,
          }
        }
      },
      jump = true,
    },
    cmd = "Trouble",
  }
}
