vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✗", -- 错误图标
      [vim.diagnostic.severity.WARN]  = "⚠", -- 警告图标
      [vim.diagnostic.severity.INFO]  = "", -- 提示图标
      [vim.diagnostic.severity.HINT]  = "", -- 细节图标
    },
  },
  virtual_text = true, -- 是否在行尾显示内联文本
  underline = true,    -- 是否下划线标记错误代码
})
