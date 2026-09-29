require("lsp_conf.base")
require("lsp_conf.lua_ls")
require("lsp_conf.vtsls")

-- lua
vim.lsp.enable("lua_ls")
-- cpp
vim.lsp.enable("clangd")
-- typescript
vim.lsp.enable('vtsls')
-- python
vim.lsp.enable('basedpyright')

