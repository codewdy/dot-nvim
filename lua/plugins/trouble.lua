return {
  {
    "folke/trouble.nvim",
    event = "LspAttach",
    opts = {
      modes = {
        sidebar_symbols = {
          mode = "symbols",
          title = "{hl:Title}Symbols{hl} {count}",
          auto_close = false,
          open_no_results = true,
          focus = false,
          follow = true,
          win = {
            position = "right",
            size = 0.3,
          },
        },
        sidebar_diagnostics = {
          mode = "diagnostics",
          title = "{hl:Title}Diagnostics{hl} {count}",
          filter = { buf = 0 },
          auto_close = false,
          open_no_results = true,
          focus = false,
          follow = true,
        },
      },
      jump = true,
    },
    config = function(_, opts)
      local trouble = require("trouble")
      trouble.setup(opts)

      local symbols_view
      local diagnostics_view
      local resizing = false
      local quitting = false

      local function resize_sidebar()
        if
          resizing
          or not symbols_view
          or not diagnostics_view
          or not symbols_view.win:valid()
          or not diagnostics_view.win:valid()
        then
          return
        end

        local symbols_win = symbols_view.win.win
        local diagnostics_win = diagnostics_view.win.win
        local total_height = vim.api.nvim_win_get_height(symbols_win) + vim.api.nvim_win_get_height(diagnostics_win)
        local diagnostics_height = math.max(1, math.floor(total_height * 0.3))

        if vim.api.nvim_win_get_height(diagnostics_win) ~= diagnostics_height then
          resizing = true
          vim.api.nvim_win_set_height(diagnostics_win, diagnostics_height)
          resizing = false
        end
      end

      local function open_sidebar()
        symbols_view = trouble.open({
          mode = "sidebar_symbols",
          focus = false,
        })

        if not symbols_view then
          return
        end

        symbols_view:wait(function()
          if not symbols_view.win:valid() then
            return
          end

          diagnostics_view = trouble.open({
            mode = "sidebar_diagnostics",
            focus = false,
            win = {
              type = "split",
              relative = "win",
              win = symbols_view.win.win,
              position = "bottom",
              size = 0.3,
            },
          })

          if diagnostics_view then
            diagnostics_view:wait(resize_sidebar)
          end
        end)
      end

      local function quit_if_only_sidebar_remains()
        vim.schedule(function()
          if
            quitting
            or not symbols_view
            or not diagnostics_view
            or not symbols_view.win:valid()
            or not diagnostics_view.win:valid()
          then
            return
          end

          local windows = vim.api.nvim_list_wins()
          if #windows ~= 2 then
            return
          end

          local sidebar_windows = {
            [symbols_view.win.win] = true,
            [diagnostics_view.win.win] = true,
          }
          if not sidebar_windows[windows[1]] or not sidebar_windows[windows[2]] then
            return
          end

          quitting = true
          local ok, err = pcall(vim.cmd, "quitall")
          if not ok then
            quitting = false
            vim.notify(err, vim.log.levels.WARN, { title = "Trouble sidebar" })
          end
        end)
      end

      local sidebar_group = vim.api.nvim_create_augroup("trouble_sidebar", { clear = true })

      vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
        group = sidebar_group,
        callback = function()
          vim.schedule(resize_sidebar)
        end,
      })

      vim.api.nvim_create_autocmd("WinClosed", {
        group = sidebar_group,
        callback = quit_if_only_sidebar_remains,
      })

      vim.schedule(function()
        open_sidebar()
      end)
    end,
    cmd = "Trouble",
  },
}
