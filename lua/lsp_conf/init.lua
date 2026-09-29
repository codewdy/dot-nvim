require("lsp_conf.base")
require("lsp_conf.lua_ls")
require("lsp_conf.vtsls")

vim.lsp.enable({
  -- lua
  "lua_ls",
  -- c, cpp
  "clangd",
  -- typescript
  "vtsls",
  -- python
  "basedpyright",
  -- json, jsonc
  "jsonls",
  -- yaml
  "yamlls",
  -- toml
  "tombi",
  -- html
  "html",
  -- css, scss, less
  "cssls",
  -- bash, sh
  "bashls",
  -- markdown, mdx
  "marksman",
  -- dockerfile
  "dockerls",
  -- xml, xsd, xsl, xslt, svg
  "lemminx",
  -- cmake
  "cmake",
})
