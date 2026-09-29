return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- optional but recommended
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      actions = require("telescope.actions")

      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            preview_cutoff = 1,
            width = 0.8,
            height = 0.8,
          },
          layout_config = {
            horizontal = {
              prompt_position = "top", -- Puts the search bar at the top
              preview_width = 0.55, -- Width of the preview pane
              results_width = 0.8,
            },
          },
          border = true,
          dynamic_preview_title = true,
          default_mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,

              ["<C-h>"] = actions.results_scrolling_left,
              ["<C-l>"] = actions.results_scrolling_right,
              ["<C-Left>"] = actions.results_scrolling_left,
              ["<C-Right>"] = actions.results_scrolling_right,

              ["<C-c>"] = actions.close,
              ["<C-q>"] = actions.close,
              ["<Esc>"] = actions.close,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<CR>"] = actions.select_default,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            },

            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              -- TODO: This would be weird if we switch the ordering.
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,

              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          live_grep = {
            path_display = {
              shorten = 2,
            },
          },
          diagnostics = {
            line_width = "full",
            path_display = "hidden",
            wrap_results = true,
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
