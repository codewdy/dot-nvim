local M = {}

function M.check()
  if vim.fn.executable("git") ~= 1 then
    return
  end

  local state = vim.fn.stdpath("state") .. "/config-update"
  local stamp = state .. "/last-check"
  local today = os.date("%Y-%m-%d")
  local ok, lines = pcall(vim.fn.readfile, stamp)
  if ok and lines[1] == today then
    return
  end

  -- Record attempts too, so offline starts and skipped updates only run once a day.
  vim.fn.mkdir(state, "p")
  vim.fn.writefile({ today }, stamp)

  local cwd = vim.fn.stdpath("config")
  local function notify(message, level)
    vim.notify("Config update: " .. message, level or vim.log.levels.INFO)
  end
  local function git(args, callback)
    local cmd = vim.list_extend({ "git", "-C", cwd }, args)
    vim.system(cmd, {
      text = true,
      timeout = 30000,
      env = { GIT_TERMINAL_PROMPT = "0" },
    }, vim.schedule_wrap(callback))
  end

  git({ "status", "--porcelain" }, function(status)
    if status.code ~= 0 then
      return -- The config directory may not be a Git checkout.
    end
    if status.stdout ~= "" then
      notify("skipped because the configuration has uncommitted changes.", vim.log.levels.WARN)
      return
    end
    git({ "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{upstream}" }, function(upstream)
      if upstream.code ~= 0 then
        notify("skipped because the current branch has no upstream.", vim.log.levels.WARN)
        return
      end
      git({ "rev-parse", "HEAD" }, function(before)
        if before.code ~= 0 then
          return
        end
        git({ "pull", "--ff-only", "--no-rebase", "--no-autostash" }, function(result)
          if result.code ~= 0 then
            notify("failed: " .. vim.trim(result.stderr or result.stdout or ""), vim.log.levels.WARN)
            return
          end
          git({ "rev-parse", "HEAD" }, function(after)
            if after.code == 0 and before.stdout ~= after.stdout then
              notify("updated successfully. Restart Neovim to load the new configuration.")
            end
          end)
        end)
      end)
    end)
  end)
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("ConfigAutoUpdate", { clear = true }),
  once = true,
  callback = function()
    -- Avoid network activity during headless checks and scripts.
    if #vim.api.nvim_list_uis() > 0 then
      vim.defer_fn(M.check, 1000)
    end
  end,
})

return M
