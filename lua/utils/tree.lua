local M = {}

function M.toggle_focus()
  if vim.bo.filetype ~= "NvimTree" then
    vim.t.tree_return_win = vim.api.nvim_get_current_win()
    require("nvim-tree.api").tree.open()
    return
  end

  local function usable(win)
    return win
      and vim.api.nvim_win_is_valid(win)
      and vim.api.nvim_win_get_tabpage(win) == vim.api.nvim_get_current_tabpage()
      and vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "NvimTree"
      and vim.api.nvim_win_get_config(win).relative == ""
  end

  local previous = vim.t.tree_return_win
  if usable(previous) then
    vim.api.nvim_set_current_win(previous)
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if usable(win) and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

return M
