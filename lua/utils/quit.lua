local M = {}

local function close_codediff()
  -- Do not load CodeDiff just to quit an ordinary buffer.
  local lifecycle = package.loaded["codediff.ui.lifecycle"]
  local tab = vim.api.nvim_get_current_tabpage()
  if not lifecycle or not lifecycle.get_session(tab) then
    return false
  end
  lifecycle.close(tab)
  -- Even if CodeDiff cancels closing, do not fall through to WintabsClose.
  return true
end

-- Central entry point for closing a buffer/window. Add future close policies here.
function M.close(opts)
  opts = opts or {}
  if close_codediff() then
    return
  end
  if vim.fn.exists(":WintabsClose") ~= 2 then
    vim.cmd.quit({ bang = opts.bang or false })
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local modified = vim.bo[buf].modified
  -- WintabsClose has no bang variant. Suppress its save prompt for this buffer.
  if opts.bang then
    vim.bo[buf].modified = false
  end
  local ok, err = pcall(vim.cmd, "WintabsClose")
  -- A buffer still used by another window must retain its unsaved state.
  -- Also restore it if closing failed or was cancelled.
  if opts.bang and vim.api.nvim_buf_is_loaded(buf) then
    vim.bo[buf].modified = modified
  end
  if not ok then
    error(err, 0)
  end
end

function M.execute(command, opts)
  opts = opts or {}
  -- In a CodeDiff tab, all quit commands close the view, including :wq/:x.
  if close_codediff() then
    return
  end
  if command == "wq" or command == "x" then
    local write = {
      cmd = command == "x" and "update" or "write",
      bang = opts.bang or false,
      args = opts.fargs or {},
    }
    if opts.range and opts.range > 0 then
      write.range = { opts.line1, opts.line2 }
    end
    -- A failed write must abort before closing.
    vim.cmd(write)
  end
  M.close(opts)
end

function M.setup()
  local commands = { q = "ConfigQuit", wq = "ConfigWriteQuit", x = "ConfigExit" }
  for name, target in pairs(commands) do
    local command = name
    local opts = { bang = true, desc = "Close through utils.quit" }
    if command ~= "q" then
      opts.nargs = "?"
      opts.complete = "file"
      opts.range = true
    end
    vim.api.nvim_create_user_command(target, function(args)
      M.execute(command, args)
    end, opts)
  end

  local aliases = {
    q = commands.q,
    quit = commands.q,
    wq = commands.wq,
    x = commands.x,
    exit = commands.x,
  }
  for alias, target in pairs(aliases) do
    -- Expand only the entire command at the start of a ':' prompt.
    -- Typing '!' triggers expansion of 'q', then appends the bang to ConfigQuit.
    vim.cmd(("cnoreabbrev <expr> %s getcmdtype() == ':' && getcmdline() == '%s' && getcmdpos() == %d ? '%s' : '%s'")
      :format(alias, alias, #alias + 1, target, alias))
  end
end

return M
