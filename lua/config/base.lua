local configure = require("config.configure")

-- configure
for k, v in pairs(configure.vim.o) do
  vim.o[k] = v
end

for k, v in pairs(configure.vim.g) do
  vim.g[k] = v
end

local function handle_root_config(config)
  local override = config[vim.bo.filetype] or {}
  local settings = vim.tbl_extend("force", {}, config["*"] or {}, override)
  for k, v in pairs(settings) do
    local ok, info = pcall(vim.api.nvim_get_option_info2, k, {})
    if ok and info.scope == "buf" then
      vim.bo[k] = v
    else
      vim.b[k] = v
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local settings = configure.filetype[vim.bo.filetype]
    while type(settings) == "string" do
      settings = configure.filetype[settings]
    end
    if type(settings) ~= "table" then
      settings = configure.filetype.default
    end

    for k, v in pairs(settings.bo or {}) do
      vim.bo[k] = v
    end

    for k, v in pairs(settings.wo or {}) do
      vim.wo[k] = v
    end

    if vim.b.root_config then
      handle_root_config(vim.b.root_config)
    end
  end,
})

-- auto chdir and load root config
local function load_root_config(root, fn)
  root = vim.fs.find(root, { path = fn, upward = true })[1]
  if not root then
    return
  end
  local readable, lines = pcall(vim.fn.readfile, root)
  if not readable then
    return
  end

  local valid, config = pcall(vim.json.decode, table.concat(lines, "\n"))
  if valid and type(config) == "table" then
    vim.b.root_config = config
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

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function(event)
    if vim.b[event.buf].root_dir then
      return
    end
    local fn = vim.api.nvim_buf_get_name(event.buf)
    if vim.fn.strcharpart(fn, 0, 1) == "/" then
      vim.api.nvim_buf_call(event.buf, function()
        vim.b.root_dir = rootdir(configure.root_files, fn)
        load_root_config(configure.root_files[1], fn)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(event)
    local root = vim.b[event.buf].root_dir
    if root then
      vim.cmd.cd(root)
    end
  end,
})
