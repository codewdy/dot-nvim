return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" }
    },
    event = "LspAttach",
    config = function ()
      require("tiny-code-action").setup{
        picker = {"snacks", opts = {}},
        backend = "difftastic",
      }
    end,
  }
}
