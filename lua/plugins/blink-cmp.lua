return {
  'saghen/blink.cmp',
  dependencies = {
    'saghen/blink.lib',
    -- 'rafamadriz/friendly-snippets',
  },
  build = function()
    require('blink.cmp').build():pwait()
  end,

  opts = {
    keymap = {
      preset = "enter",
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<S-h>'] = { 'snippet_backward', 'fallback' },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
    },
    completion = {
      documentation = { auto_show = false },
      list = {
        selection = { preselect = false, auto_insert = true },
      },
      ghost_text = {
        enabled = true,
        show_without_selection = true,
        show_first_line_only = true,
      },
    },
    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
}
