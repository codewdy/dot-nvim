return {
  {
    "voldikss/vim-floaterm",
    init = function()
      vim.g.floaterm_autoinsert = "always"
      vim.g.floaterm_autoclose = 2
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_opener = "e"
      vim.api.nvim_create_autocmd({ "TermEnter", "InsertEnter" }, {
        group = vim.api.nvim_create_augroup("FloatermAutoinsert", { clear = true }),
        callback = function(event)
          if vim.bo[event.buf].filetype ~= "floaterm" then
            return
          end
          -- Terminal input uses TermEnter rather than InsertEnter.
          vim.fn["floaterm#config#set"](event.buf, "autoinsert", "always")
          vim.b[event.buf].floaterm_restore_visual = false
        end,
      })
    end,
  },
}
