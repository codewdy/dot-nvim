vim.lsp.config("eslint", {
  settings = {
    run = "onType",
    format = false,
    codeActionOnSave = {
      enable = false,
    },
  },
})
