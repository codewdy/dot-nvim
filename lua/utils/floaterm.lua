local M = {}

function M.toggle(from_terminal_mode, from_visual_mode)
  if vim.bo.filetype == "floaterm" then
    -- Remember each terminal's mode before hiding it.
    vim.fn["floaterm#config#set"](vim.api.nvim_get_current_buf(), "autoinsert", from_terminal_mode and "always" or "never")
    vim.b.floaterm_restore_visual = from_visual_mode == true
  end
  vim.cmd("FloatermToggle")
  if vim.bo.filetype == "floaterm" and vim.b.floaterm_restore_visual then
    -- Run after Floaterm's queued keys that restore terminal Normal mode.
    vim.api.nvim_feedkeys("gv", "n", false)
  end
end

return M
