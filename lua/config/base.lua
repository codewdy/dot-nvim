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
    while type(configure.filetype[filetype]) == "string" do
      filetype = configure.filetype[filetype]
    end
    if configure.filetype[filetype] == nil then
      filetype = "default"
    end

    for k, v in pairs(configure.filetype[filetype].bo or {}) do
      vim.bo[k] = v
    end

    for k, v in pairs(configure.filetype[filetype].wo or {}) do
      vim.wo[k] = v
    end
  end,
})

-- auto chdir and load root config
local function handle_root_config(config)
  for k, v in pairs(config.bo or {}) do
    vim.bo[k] = v
  end
  for k, v in pairs(config.b or {}) do
    vim.b[k] = v
  end
end

local function load_root_config(root, fn)
  local root = vim.fs.find(root, { path = fn, upward = true })[1]
  if not root then
    return
  end
  local readable, lines = pcall(vim.fn.readfile, root)
  if not readable then
    return
  end

  local valid, config = pcall(vim.json.decode, table.concat(lines, "\n"))
  if valid then
    handle_root_config(config)
  end
end

local function rootdir(root_files, file_path)
  for _, p in ipairs(root_files) do
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
      load_root_config(configure.root_files[1], fn)
    end
  end,
})
