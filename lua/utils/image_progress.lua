local M = {}

function M.setup(image)
  local namespace = vim.api.nvim_create_namespace("ImageRenderProgress")
  local active
  local function show(buf, message, highlight)
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)
    if message then
      vim.api.nvim_buf_set_extmark(buf, namespace, 0, 0, {
        virt_text = { { " " .. message, highlight or "Comment" } },
        virt_text_pos = "overlay",
        priority = 200,
      })
    end
  end

  local function finish(message)
    if not active then
      return
    end
    show(active.buf, message, "WarningMsg")
    active = nil
  end

  local function start()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].filetype ~= "image_nvim" or not image.is_enabled() then
      return
    end
    local win = vim.api.nvim_get_current_win()
    for _, img in ipairs(image.get_images({ buffer = buf, window = win })) do
      if img.is_rendered then
        return
      end
    end

    if active and active.buf == buf and active.win == win then
      show(buf, "渲染中…")
      return
    end
    finish()
    local task = { buf = buf, win = win, started = vim.uv.hrtime() }
    active = task
    show(buf, "渲染中…")
    -- Flush the message before ImageMagick's synchronous Sixel encoding starts.
    vim.cmd("redraw")

    local function check()
      if active ~= task then
        return
      end
      if vim.api.nvim_get_current_buf() ~= buf or vim.api.nvim_get_current_win() ~= win or not image.is_enabled() then
        finish()
        return
      end
      for _, img in ipairs(image.get_images({ buffer = buf, window = win })) do
        -- The Sixel backend sets this only after encoding and writing the image.
        if img.is_rendered then
          finish()
          return
        end
      end
      if (vim.uv.hrtime() - task.started) / 1e9 >= 15 then
        finish("图片渲染未完成，请检查 :messages")
        return
      end
      vim.defer_fn(check, 100)
    end
    vim.defer_fn(check, 100)
  end

  local group = vim.api.nvim_create_augroup("ImageRenderProgress", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "image_nvim",
    callback = start,
  })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "VimEnter" }, {
    group = group,
    callback = start,
  })
  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave", "VimLeavePre" }, {
    group = group,
    callback = function()
      finish()
    end,
  })
end

return M
