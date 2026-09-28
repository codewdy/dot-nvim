return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-telescope/telescope.nvim" }
    },
    event = "LspAttach",
    config = function ()
      require("tiny-code-action").setup{
        picker = {"telescope", opts = {}},
        backend = "difftastic",
      }
      require("telescope.builtin").code_action = require("tiny-code-action").code_action
    end,
  }
}
