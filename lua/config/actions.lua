require("utils.action").register({
  name = "user-define-action",
  prioirty = 1000,
  actions = {
    generate_root = require("actions.generate_root"),
    lsp_rename = vim.lsp.buf.rename,
    switch_source_header = function()
      vim.cmd([[ LspClangdSwitchSourceHeader ]])
    end,
  },
})
