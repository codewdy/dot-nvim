return {
  {
    'zefei/vim-wintabs',
    config = function()
      vim.g.wintabs_autoclose_vim = true
      vim.g.wintabs_autoclose = 1
      require("utils.quit").setup()
     end
  },
  "zefei/vim-wintabs-powerline"
}
