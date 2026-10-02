local M = {}

local function get_diagnostics(line)
  local diagnostics = vim.diagnostic.get(0, line and { lnum = line } or nil)
  if #diagnostics == 0 then
    local location = line and "on the current line" or "in the current buffer"
    vim.notify("No diagnostics " .. location, vim.log.levels.INFO)
    return
  end

  table.sort(diagnostics, function(a, b)
    if a.lnum == b.lnum then
      return a.col < b.col
    end
    return a.lnum < b.lnum
  end)

  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  return diagnostics, filename ~= "" and filename or "[No Name]"
end

local function format(diagnostic, filename)
  return ("%s:%d: %s"):format(filename, diagnostic.lnum + 1, diagnostic.message)
end

local function copy(diagnostics, filename)
  local messages = {}
  for _, diagnostic in ipairs(diagnostics) do
    messages[#messages + 1] = format(diagnostic, filename)
  end
  local text = table.concat(messages, "\n")
  vim.fn.setreg("+", text)
  vim.fn.setreg("*", text)
  vim.notify(("Copied %d diagnostic(s)"):format(#diagnostics), vim.log.levels.INFO)
end

function M.copy_diagnostic()
  local diagnostics, filename = get_diagnostics()
  if not diagnostics then
    return
  end

  require("snacks").picker.diagnostics_buffer({
    title = "Copy diagnostic",
    preview = "file",
    layout = { preview = true },
    confirm = function(picker, item)
      if item then
        picker:close()
        copy({ item.item }, filename)
      end
    end,
  })
end

function M.copy_diagnostic_line()
  local diagnostics, filename = get_diagnostics(vim.api.nvim_win_get_cursor(0)[1] - 1)
  if diagnostics then
    copy(diagnostics, filename)
  end
end

function M.copy_diagnostic_document()
  local diagnostics, filename = get_diagnostics()
  if diagnostics then
    copy(diagnostics, filename)
  end
end

return M
