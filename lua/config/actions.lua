require("utils.action").register({
  name = "user-define-action",
  prioirty = 1000,
  actions = {
    lsp_rename = vim.lsp.buf.rename,
    switch_source_header = function()
      vim.cmd([[ LspClangdSwitchSourceHeader ]])
    end,
  },
})
