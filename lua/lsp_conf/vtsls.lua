vim.lsp.config("vtsls", {
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true, -- 优先使用项目的 TypeScript
    },
  },
})
vim.lsp.enable("vtsls")
