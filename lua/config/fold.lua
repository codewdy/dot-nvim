local M = {}

local function fit(text, width)
  local result = ""
  for i = 0, vim.fn.strchars(text) - 1 do
    local char = vim.fn.strcharpart(text, i, 1)
    if char == "\t" then
      char = string.rep(" ", vim.bo.tabstop - vim.fn.strdisplaywidth(result) % vim.bo.tabstop)
    end
    if vim.fn.strdisplaywidth(result .. char) > width then
      return result
    end
    result = result .. char
  end
  return result
end

function M.text()
  local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local width = math.max(0, vim.api.nvim_win_get_width(0) - info.textoff)
  local count = vim.v.foldend - vim.v.foldstart + 1
  local percent = math.floor(count * 100 / vim.api.nvim_buf_line_count(0))
  local suffix = string.format(" %d lines · %d%%", count, percent)
  local suffix_width = vim.fn.strdisplaywidth(suffix)
  if suffix_width >= width then
    return fit(suffix, width)
  end

  local available = width - suffix_width - 1
  local content = vim.fn.getline(vim.v.foldstart):gsub("%s+$", "")
  local left = fit(content, available)
  if vim.fn.strdisplaywidth(content) > available then
    left = fit(content, math.max(0, available - 1)) .. (available > 0 and "…" or "")
  end
  left = left .. " "
  return left .. string.rep("·", width - vim.fn.strdisplaywidth(left) - suffix_width) .. suffix
end

function M.update(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
    return
  end

  local method, expr = "indent", "0"
  if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/foldingRange" }) > 0 then
    method, expr = "expr", "v:lua.vim.lsp.foldexpr()"
  else
    local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
    if ok and parser then
      local valid, query = pcall(vim.treesitter.query.get, parser:lang(), "folds")
      if valid and query then
        method, expr = "expr", "v:lua.vim.treesitter.foldexpr()"
      end
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
    if not vim.wo[win].diff then
      vim.wo[win].foldtext = "v:lua.require'config.fold'.text()"
      vim.wo[win].foldexpr = expr
      vim.wo[win].foldmethod = method
    end
  end
end

vim.opt.foldtext = "v:lua.require'config.fold'.text()"
local group = vim.api.nvim_create_augroup("AutoFoldMethod", { clear = true })
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "LspAttach", "LspDetach" }, {
  group = group,
  callback = function(event)
    -- Wait for filetype setup and LSP detach to finish before checking capabilities.
    vim.schedule(function()
      M.update(event.buf)
    end)
  end,
})
M.update(vim.api.nvim_get_current_buf())

return M
