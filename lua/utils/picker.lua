local M = {}

function M.show()
  local cb = M.all_pickers()
  local names = vim.tbl_keys(cb)
  table.sort(names)

  vim.ui.select(names, {
    prompt = "pickers",
  }, function(name)
    if not name then
      return
    end
    cb[name]()
  end)
end

function M.all_pickers()
  rst = {}
  for k, v in pairs(require("snacks").picker) do
    rst[k] = v
  end
  rst["code_action"] = require("tiny-code-action").code_action
  return rst
end

return M
