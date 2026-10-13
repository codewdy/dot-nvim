local default = {
  ["*"] = {
    disable_autoformat = false,
    diagnostic_level = "INFO", -- ERROR, WARN, INFO, HINT (minimum retained severity)
  },
}

local function root_files(dir)
  local files = {}
  for _, name in ipairs(require("config.configure").root_files[1]) do
    local path = vim.fs.joinpath(dir, name)
    local stat = vim.uv.fs_stat(path)
    if stat and stat.type == "file" then
      files[#files + 1] = name
    end
  end
  return files
end

local function generate(dir)
  local files = root_files(dir)
  local root = files[1] and vim.fs.joinpath(dir, files[1])
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
    root = vim.fs.joinpath(dir, require("config.configure").root_files[1][1])
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

return function()
  local cwd = vim.fn.getcwd()
  require("snacks").picker({
    title = "Generate root: select directory",
    layout = { preset = "select" },
    finder = function(_, ctx)
      local has_git = vim.fn.executable("git") == 1
      local fd = vim.fn.executable("fd") == 1
        and require("snacks.picker.source.proc").proc({
          cmd = "fd",
          args = { "-t", "d", "--color", "never", "--absolute-path", "--print0" },
          cwd = cwd,
          sep = "\0",
        }, ctx)
      return function(cb)
        local function add(dir)
          local files = root_files(dir)
          local status = #files > 0 and ("[exists: " .. table.concat(files, ", ") .. "]") or "[no rootfile]"
          cb({
            text = dir .. " " .. status .. (dir == cwd and " [cwd]" or ""),
            directory = dir,
          })
        end

        add(cwd)
        for parent in vim.fs.parents(cwd) do
          add(parent)
        end
        if fd then
          fd(function(item)
            add(vim.fs.normalize(item.text))
          end)
          return
        end

        local process
        ctx.async:on("abort", function()
          if process then
            process:kill(15)
          end
        end)
        local function git(args, stdin)
          local command = { "git", "-C", cwd }
          vim.list_extend(command, args)
          local result
          ctx.async:schedule(function()
            if ctx.async:aborted() then
              return
            end
            process = vim.system(command, { stdin = stdin }, function(completed)
              result = completed
              process = nil
              ctx.async:resume()
            end)
          end)
          while not result do
            ctx.async:suspend()
          end
          return result
        end
        local use_git = false
        if has_git then
          local result = git({ "rev-parse", "--is-inside-work-tree" })
          use_git = result.code == 0 and vim.trim(result.stdout) == "true"
        end

        local directories = { cwd }
        while #directories > 0 do
          local candidates = {}
          for _, dir in ipairs(directories) do
            -- Scan one level so ignored directories are never traversed.
            for name, kind in vim.fs.dir(dir) do
              if kind == "directory" and not name:match("^%.") then
                candidates[#candidates + 1] = vim.fs.joinpath(dir, name)
              end
            end
          end

          local ignored = {}
          if use_git and #candidates > 0 then
            -- Git detects directory types; NULs preserve spaces and newlines in names.
            local result = git({ "check-ignore", "--stdin", "-z" }, table.concat(candidates, "\0") .. "\0")
            if result.code == 0 or result.code == 1 then
              for _, path in ipairs(vim.split(result.stdout, "\0", { plain = true, trimempty = true })) do
                ignored[path] = true
              end
            else
              use_git = false
              vim.schedule(function()
                vim.notify("Cannot check Git ignore rules: " .. (result.stderr or ""), vim.log.levels.WARN)
              end)
            end
          end

          directories = {}
          for _, dir in ipairs(candidates) do
            if not ignored[dir] then
              add(dir)
              directories[#directories + 1] = dir
            end
          end
        end
      end
    end,
    format = "text",
    confirm = function(picker, item)
      picker:close()
      if item then
        generate(item.directory)
      end
    end,
  })
end
