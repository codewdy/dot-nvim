return {
  {
    'stevearc/aerial.nvim',
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("aerial").setup{
        open_automatic = true,
        attach_mode = "window",
        close_automatic_events = { "unsupported" },
        layout = {
          width = 0.3,
          win_opts = {},
          default_direction = "prefer_right",
          placement = "edge",
          preserve_equality = false,
        },
      }
      require("telescope.builtin").symbols = require("telescope").extensions.aerial.aerial
    end,
  }
}
