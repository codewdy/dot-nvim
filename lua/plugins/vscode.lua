return {
  {
    "Mofiqul/vscode.nvim",
    config = function()
      vim.g.vscode_style = "dark"
      vim.cmd("colorscheme vscode")
    end,
  },
}
