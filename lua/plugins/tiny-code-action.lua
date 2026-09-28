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
        backend = "delta",
        backend_opts = {
          delta = {
            header_lines_to_remove = 0,
            args = require("utils.delta").args({
              -- Ignore global diff.external when comparing the temporary files.
              "--diff-args=--no-ext-diff",
              "--file-style=omit",
              "--hunk-header-style=omit",
            }),
          },
        },
        require("utils.action").register{
          name = "code-action",
          actions = { code_action = require("tiny-code-action").code_action }
        }
      }
    end,
  }
}
