return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        toggler = { line = "#", block = "$" },
        opleader = { line = "#", block = "$" },
        mappings = { basic = true, extra = false },
      })
    end,
  },
}
