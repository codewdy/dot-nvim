local M = {}

M.providers = {}

---@param provider { name: string, actions: table<string, function>|fun(): table<string, function>, priority?: number }
function M.register(provider)
  M.providers[provider.name] = provider
end

function M.all_actions()
  local providers = vim.tbl_values(M.providers)
  -- Higher priorities override duplicate action names. Break ties by provider name.
  table.sort(providers, function(a, b)
    local a_priority, b_priority = a.priority or 0, b.priority or 0
    if a_priority == b_priority then
      return a.name < b.name
    end
    return a_priority < b_priority
  end)

  local actions = {}
  for _, provider in ipairs(providers) do
    local provided = provider.actions
    if type(provided) == "function" then
      provided = provided()
    end
    for name, callback in pairs(provided) do
      actions[name] = callback
    end
  end
  return actions
end

function M.show()
  local cb = M.all_actions()
  local names = vim.tbl_keys(cb)
  table.sort(names)

  vim.ui.select(names, {
    prompt = "actions",
  }, function(name)
    if not name then
      return
    end
    cb[name]()
  end)
end

return M
