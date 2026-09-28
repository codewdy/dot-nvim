return {
  {
    "voldikss/vim-floaterm",
    init = function()
      vim.g.floaterm_autoinsert = "smart"
      vim.g.floaterm_autoclose = 2
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_opener = 'e'
      local group = vim.api.nvim_create_augroup("FloatermSmartIntegration", {
        clear = true,
      })

      local function is_floaterm(bufnr)
        return vim.api.nvim_buf_is_valid(bufnr)
          and vim.bo[bufnr].filetype == "floaterm"
      end

      local function enter_terminal_mode(bufnr)
        -- Floaterm's `never` handler may have queued <C-\><C-n>. Run on the
        -- next event-loop turn so our mode decision is applied last.
        vim.defer_fn(function()
          if is_floaterm(bufnr)
            and vim.api.nvim_get_current_buf() == bufnr
            and vim.b[bufnr].floaterm_should_insert ~= false
          then
            vim.cmd("startinsert")
          end
        end, 0)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "floaterm",
        callback = function(args)
          -- A newly created terminal starts at its shell prompt.
          vim.b[args.buf].floaterm_should_insert = true
        end,
      })

      vim.api.nvim_create_autocmd("BufLeave", {
        group = group,
        callback = function(args)
          if not is_floaterm(args.buf) then
            return
          end

          local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
          local last_nonblank = vim.fn.prevnonblank(vim.fn.line("$"))

          -- Save a boolean now instead of comparing absolute line numbers
          -- after the hidden terminal has produced more output.
          vim.b[args.buf].floaterm_should_insert = cursor_line >= last_nonblank
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        callback = function(args)
          if is_floaterm(args.buf) then
            enter_terminal_mode(args.buf)
          end
        end,
      })

      -- A new Floaterm enters its window before its filetype has been set, so
      -- its first BufEnter cannot identify it. FloatermOpen covers that case.
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "FloatermOpen",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          if is_floaterm(bufnr) then
            enter_terminal_mode(bufnr)
          end
        end,
      })
    end
  },
}
