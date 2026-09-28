local M = {}

function M.args(extra)
  return vim.list_extend({
    "--paging=never",
    "--line-numbers",
    "--minus-style=red bold normal",
    "--plus-style=green bold normal",
    "--minus-emph-style=red bold normal",
    "--plus-emph-style=green bold normal",
    "--minus-empty-line-marker-style=red bold normal",
    "--plus-empty-line-marker-style=green bold normal",
  }, extra or {})
end

function M.cmd(extra)
  return vim.list_extend({ "delta" }, M.args(extra))
end

return M
