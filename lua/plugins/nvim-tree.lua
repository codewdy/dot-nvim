return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  -- Adapted from alex-courtis/arch at b5f24e0 (without its mappings).
  opts = {
    hijack_cursor = true,
    sync_root_with_cwd = true,
    view = {
      side = "left",
      width = 30,
    },
    renderer = {
      full_name = true,
      group_empty = true,
      special_files = {},
      symlink_destination = false,
      indent_markers = {
        enable = true,
      },
      icons = {
        git_placement = "signcolumn",
        show = {
          file = true,
          folder = true,
          folder_arrow = false,
          git = true,
        },
      },
    },
    update_focused_file = {
      enable = true,
      update_root = {
        enable = true,
        ignore_list = { "help" },
      },
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
    },
    filters = {
      custom = { "^.git$" },
    },
    actions = {
      change_dir = {
        enable = false,
        restrict_above_cwd = true,
      },
      open_file = {
        resize_window = true,
        window_picker = {
          chars = "aoeui",
        },
      },
      remove_file = {
        close_window = false,
      },
    },
    log = {
      enable = false,
      truncate = true,
      types = {
        all = false,
        config = false,
        copy_paste = false,
        diagnostics = false,
        git = false,
        profile = false,
        watcher = false,
      },
    },
  },
  config = function(_, opts)
    require("utils.tree").setup_root_indent()
    require("nvim-tree").setup(opts)
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("NvimTreeStartup", { clear = true }),
      once = true,
      callback = function()
        vim.schedule(function()
          local win = vim.api.nvim_get_current_win()
          require("nvim-tree.api").tree.open()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
          end
        end)
      end,
    })
  end,
}
