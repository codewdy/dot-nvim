-- Filter before storage so all vim.diagnostic consumers see the same diagnostics.
local diagnostic_set = vim.diagnostic.set
vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
  local level = vim.b[bufnr].diagnostic_level
  local threshold = type(level) == "string" and vim.diagnostic.severity[level:upper()] or nil
  if type(threshold) ~= "number" then
    threshold = vim.diagnostic.severity.INFO
  end

  local filtered = {}
  for _, diagnostic in ipairs(diagnostics) do
    local severity = diagnostic.severity or vim.diagnostic.severity.ERROR
    if type(severity) == "string" then
      severity = vim.diagnostic.severity[severity:upper()]
    end
    if severity <= threshold then
      filtered[#filtered + 1] = diagnostic
    end
  end
  return diagnostic_set(namespace, bufnr, filtered, opts)
end

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗", -- 错误图标
      [vim.diagnostic.severity.WARN] = "⚠", -- 警告图标
      [vim.diagnostic.severity.INFO] = "", -- 提示图标
      [vim.diagnostic.severity.HINT] = "", -- 细节图标
    },
  },
  virtual_text = true, -- 是否在行尾显示内联文本
  underline = true, -- 是否下划线标记错误代码
})
