return {
  {
    "rhysd/accelerated-jk",
    config = function()
      vim.cmd([[nmap j <Plug>(accelerated_jk_gj)]])
      vim.cmd([[nmap k <Plug>(accelerated_jk_gk)]])
      vim.cmd([[nmap <Down> <Plug>(accelerated_jk_gj)]])
      vim.cmd([[nmap <Up> <Plug>(accelerated_jk_gk)]])
    end,
  },
}
