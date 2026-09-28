function wintabs_cabbrev_wq()
  vim.cmd('w')
  vim.cmd('WintabsClose')
end

return {
  {
    'zefei/vim-wintabs',
    config = function()
      vim.g.wintabs_autoclose_vim = true
      vim.g.wintabs_autoclose = 1
      vim.cmd([[cabbrev wq <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'lua wintabs_cabbrev_wq()' : 'wq')<CR>]])
      vim.cmd([[cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'WintabsClose' : 'q')<CR>]])
      vim.cmd([[cabbrev q! <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'WintabsClose' : 'q!')<CR>]])
     end
  },
  "zefei/vim-wintabs-powerline"
}
