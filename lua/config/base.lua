local configure = require("config.configure")

-- configure
for k, v in pairs(configure.vim.o) do
  vim.o[k] = v
end

for k, v in pairs(configure.vim.g) do
  vim.g[k] = v
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    filetype = vim.bo.filetype
    while type(configure.filetype[filetype]) == 'string' do
      filetype = configure.filetype[filetype]
    end
    if configure.filetype[filetype] == nil then
      filetype = 'default'
    end

    for k, v in pairs(configure.filetype[filetype].bo or {}) do
      vim.bo[k] = v
    end

    for k, v in pairs(configure.filetype[filetype].wo or {}) do
      vim.wo[k] = v
    end
  end
})

-- auto chdir
local function rootdir(root_files, file_path)
  for _,p in ipairs(root_files) do
    local root = vim.fs.dirname(vim.fs.find(p, { path = file_path, upward = true })[1])
    if root then
      return root
    end
  end
  return vim.fs.dirname(file_path)
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local fn = vim.api.nvim_buf_get_name(0)
    if vim.fn.strcharpart(fn, 0, 1) == "/" then
      vim.cmd.cd(rootdir(configure.root_files, fn))
    end
  end,
})
