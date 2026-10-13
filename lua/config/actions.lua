require("utils.action").register({
  name = "user-define-action",
  prioirty = 1000,
  actions = {
    check_dependencies = require("actions.check_dependencies"),
    copy_diagnostic = require("actions.copy_diagnostic").copy_diagnostic,
    copy_diagnostic_document = require("actions.copy_diagnostic").copy_diagnostic_document,
    copy_diagnostic_line = require("actions.copy_diagnostic").copy_diagnostic_line,
    generate_root = require("actions.generate_root"),
    lsp_rename = vim.lsp.buf.rename,
    diagnostic_line = vim.diagnostic.open_float,
    switch_source_header = function()
      vim.cmd([[ LspClangdSwitchSourceHeader ]])
    end,
  },
})
