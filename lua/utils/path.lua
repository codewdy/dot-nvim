local vim = vim
local validate = vim.validate
local api = vim.api
local uv = vim.loop
local fn = vim.fn

local M = {}

function M.exists(filename)
  local stat = uv.fs_stat(filename)
  return stat and stat.type or false
end

function M.is_dir(filename)
  return exists(filename) == 'directory'
end

function M.is_file(filename)
  return exists(filename) == 'file'
end

local is_windows = uv.os_uname().version:match 'Windows'
local path_sep = is_windows and '\\' or '/'

if is_windows then
  is_fs_root = function(path)
    return path:match '^%a:$'
  end
else
  is_fs_root = function(path)
    return path == '/'
  end
end

function M.is_absolute(filename)
  if is_windows then
    return filename:match '^%a:' or filename:match '^\\\\'
  else
    return filename:match '^/'
  end
end

local strip_dir_pat = path_sep .. '([^' .. path_sep .. ']+)$'
local strip_sep_pat = path_sep .. '$'
function M.dirname(path)
  if not path or #path == 0 then
    return
  end
  local result = path:gsub(strip_sep_pat, ''):gsub(strip_dir_pat, '')
  if #result == 0 then
    return '/'
  end
  return result
end

function M.join(...)
  local result = table.concat(vim.tbl_flatten { ... }, path_sep):gsub(path_sep .. '+', path_sep)
  return result
end

function M.traverse_parents(path, cb)
  local path = uv.fs_realpath(path)
  local dir = path
  -- Just in case our algo is buggy, don't infinite loop.
  for _ = 1, 100 do
    dir = dirname(dir)
    if not dir then
      return
    end
    -- If we can't ascend further, then stop looking.
    if cb(dir, path) then
      return dir, path
    end
    if is_fs_root(dir) then
      break
    end
  end
end

function M.iterate_parents(path)
  local function it(_, v)
    if v and not is_fs_root(v) then
      v = M.dirname(v)
    else
      return
    end
    if v and uv.fs_realpath(v) then
      return v, path
    else
      return
    end
  end
  return it, path, path
end

function M.is_descendant(root, path)
  if not path then
    return false
  end

  local function cb(dir, _)
    return dir == root
  end

  local dir, _ = traverse_parents(path, cb)

  return dir == root
end

function M.search_ancestors(startpath, func)
  startpath = uv.fs_realpath(startpath)
  validate { func = { func, 'f' } }
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in M.iterate_parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
  xxx = nil
  return nil
end

function M.root_pattern(all_patterns)
  local function gen_matcher(patterns)
    return function (path)
      for _, pattern in ipairs(patterns) do
        for _, p in ipairs(vim.fn.glob(M.join(path, pattern), true, true)) do
          if M.exists(p) then
            return path
          end
        end
      end
    end
  end
  return function(startpath)
    for _,p in ipairs(all_patterns) do
      local rst = M.search_ancestors(startpath, gen_matcher(p))
      if rst ~= nil then
        return rst
      end
    end
    return startpath
  end
end

return M
