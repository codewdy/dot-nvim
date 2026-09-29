return {
  {
    "voldikss/vim-floaterm",
    init = function()
      vim.g.floaterm_autoinsert = "always"
      vim.g.floaterm_autoclose = 2
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_opener = "e"
    end,
  },
}
