require("lsp_conf.base")
require("lsp_conf.lua_ls")
require("lsp_conf.vtsls")
require("lsp_conf.eslint")

local servers = {
  -- lua
  "lua_ls",
  -- c, cpp
  "clangd",
  -- typescript
  "vtsls",
  "eslint",
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
}

vim.lsp.enable(servers)

return servers
