local default = {
  b = {
    disable_autoformat = false,
  },
}

return function()
  local configure = require("config.configure")
  local cwd = vim.fn.getcwd()
  local root = vim.fs.find(configure.root_files[1], { path = cwd, upward = true })[1]
  local config = {}

  if root then
    local readable, lines = pcall(vim.fn.readfile, root)
    if not readable then
      vim.notify("Cannot read root config: " .. tostring(lines), vim.log.levels.ERROR)
      return
    end
    local content = table.concat(lines, "\n")
    if content:find("%S") then
      local valid, decoded = pcall(vim.json.decode, content)
      if not valid or type(decoded) ~= "table" or not content:match("^%s*{") then
        vim.notify("Root config must be a JSON object: " .. root, vim.log.levels.ERROR)
        return
      end
      config = decoded
    end
  else
    root = vim.fs.joinpath(cwd, configure.root_files[1][1])
  end

  config = vim.tbl_deep_extend("force", {}, default, config)
  local encoded, content = pcall(vim.json.encode, config, { indent = "  ", sort_keys = true })
  if not encoded then
    vim.notify("Cannot encode root config: " .. tostring(content), vim.log.levels.ERROR)
    return
  end
  local written, err = pcall(vim.fn.writefile, vim.split(content, "\n", { plain = true }), root)
  if not written or err ~= 0 then
    vim.notify("Cannot write root config: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  vim.notify("Root config written: " .. root)
end
