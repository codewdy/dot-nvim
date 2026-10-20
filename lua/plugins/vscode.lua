return {
  {
    "Mofiqul/vscode.nvim",
    config = function()
      require("vscode").setup({
        terminal_colors = false,
      })
      vim.g.vscode_style = "dark"
      vim.cmd("colorscheme vscode")
    end,
  },
}
