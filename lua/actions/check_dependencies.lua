-- Alternatives in one entry only require one executable to be present.
local tools = {
  { { "git" }, "plugin management and Git integration" },
  { { "rg" }, "ripgrep: text search" },
  { { "fd", "fdfind", "rg", "find" }, "file search" },
  { { "delta" }, "Git and code-action previews" },
  { { "lazygit" }, "Lazygit action" },
  { { "node" }, "JavaScript-based language servers and formatters" },
  { { "python3", "python" }, "Python-based language servers and formatters" },
  { { "java" }, "Lemminx language server" },
  { { "curl" }, "Treesitter parser downloads" },
  { { "tar" }, "Treesitter parser extraction" },
  { { "tree-sitter" }, "Treesitter parser generation" },
  { { "cc", "gcc", "clang", "cl" }, "Treesitter and telescope-fzf-native builds" },
  { { "make" }, "telescope-fzf-native build" },
  { { "cargo" }, "blink.cmp build" },
}

-- These lspconfig commands are functions that prefer project-local executables.
local local_servers = {
  cssls = "vscode-css-language-server",
  html = "vscode-html-language-server",
  jsonls = "vscode-json-language-server",
  yamlls = "yaml-language-server",
}

return function()
  local missing, unchecked = {}, {}
  local checked = 0
  local function check(available, label)
    checked = checked + 1
    if not available then
      missing[#missing + 1] = label
    end
  end
  local function executable(commands, purpose)
    for _, command in ipairs(commands) do
      if vim.fn.executable(command) == 1 then
        check(true, purpose)
        return
      end
    end
    check(false, table.concat(commands, " / ") .. " — " .. purpose)
  end

  for _, dependency in ipairs(tools) do
    executable(dependency[1], dependency[2])
  end
  executable({ vim.o.shell }, "configured terminal shell")

  local has_lazy, lazy = pcall(require, "lazy.core.config")
  if has_lazy then
    for name, plugin in pairs(lazy.plugins) do
      if not plugin.virtual then
        local stat = plugin.dir and vim.uv.fs_stat(plugin.dir)
        check(stat ~= nil and stat.type == "directory", "plugin: " .. name .. " (install with :Lazy sync)")
      end
    end
  else
    check(false, "lazy.nvim — plugin manager")
  end

  for _, name in ipairs(require("lsp_conf")) do
    if vim.lsp.is_enabled(name) then
      local config = vim.lsp.config[name]
      local cmd = config and config.cmd
      if type(cmd) == "table" and type(cmd[1]) == "string" then
        executable({ cmd[1] }, "LSP: " .. name)
      elseif type(cmd) == "function" and local_servers[name] then
        local command = local_servers[name]
        local root = type(config.root_dir) == "string" and config.root_dir
          or vim.fs.root(0, config.root_markers or { ".git" })
        local commands = { command }
        if root then
          commands[#commands + 1] = vim.fs.joinpath(root, "node_modules", ".bin", command)
        end
        executable(commands, "LSP: " .. name)
      else
        unchecked[#unchecked + 1] = "LSP: " .. name .. " (no static executable to check)"
      end
    end
  end

  local has_conform, conform = pcall(require, "conform")
  if has_conform then
    local ok, formatters = pcall(conform.list_all_formatters)
    if ok then
      for _, formatter in ipairs(formatters) do
        check(
          formatter.available,
          "formatter: " .. formatter.name .. " — " .. (formatter.available_msg or formatter.command or "unavailable")
        )
      end
    else
      unchecked[#unchecked + 1] = "formatters: " .. tostring(formatters)
    end
  else
    unchecked[#unchecked + 1] = "formatters: conform.nvim is unavailable"
  end

  table.sort(missing)
  table.sort(unchecked)
  local lines = { ("Dependencies: %d checked, %d missing/unavailable."):format(checked, #missing) }
  for _, label in ipairs(missing) do
    lines[#lines + 1] = "- " .. label
  end
  if #unchecked > 0 then
    lines[#lines + 1] = "Could not check:"
    for _, label in ipairs(unchecked) do
      lines[#lines + 1] = "- " .. label
    end
  end
  lines[#lines + 1] = "Checks presence only; formatter resolution uses the current buffer/project."
  vim.notify(
    table.concat(lines, "\n"),
    (#missing > 0 or #unchecked > 0) and vim.log.levels.WARN or vim.log.levels.INFO,
    {
      title = "Dependency check",
      timeout = 20000,
    }
  )
end
