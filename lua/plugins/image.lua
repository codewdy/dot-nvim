return {
  "3rd/image.nvim",
  build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  opts = {
    processor = "magick_cli",
    backend = "sixel",
    -- Hide images while floating windows (such as Floaterm) cover their window.
    window_overlap_clear_enabled = true,
    editor_only_render_when_focused = true,
    max_height_window_percentage = 100,
    max_width_window_percentage = 100,
  },
  config = function(_, opts)
    if opts.backend == "sixel" and vim.env.TMUX then
      local support = vim.fn.system({ "tmux", "display-message", "-p", "#{sixel_support}" })
      if vim.v.shell_error == 0 and vim.trim(support) == "1" then
        local tmux = require("image/utils/tmux")
        local escape = tmux.escape
        tmux.escape = function(sequence)
          -- Let tmux retain Sixel images and repaint them with the pane.
          -- Keep passthrough wrapping for other terminal protocols.
          if sequence:match("^\27P[0-9;]*q") or sequence:match("^\155[0-9;]*q") then
            return sequence
          end
          return escape(sequence)
        end
      end
    end

    local image = require("image")
    image.setup(opts)
    require("utils.image_progress").setup(image)

    vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
      group = vim.api.nvim_create_augroup("ImageFloatermVisibility", { clear = true }),
      callback = function(event)
        if vim.bo[event.buf].filetype ~= "floaterm" then
          return
        end

        image.clear()
      end,
    })
  end,
}
