return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    view = {
      side = "left",
      width = 30,
    },
    update_focused_file = {
      enable = true,
    },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("NvimTreeStartup", { clear = true }),
      once = true,
      callback = function()
        vim.schedule(function()
          local win = vim.api.nvim_get_current_win()
          require("nvim-tree.api").tree.open()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
          end
        end)
      end,
    })
  end,
}
