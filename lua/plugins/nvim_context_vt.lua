return {
  {
    'andersevenrud/nvim_context_vt',
    config = function()
      require('nvim_context_vt').setup({
        -- Enable by default. You can disable and use :NvimContextVtToggle to maually enable.
        -- Default: true
        enabled = true,

        -- Override default virtual text prefix
        -- Default: '-->'
        prefix = '-->',

        -- Override default virtual text priority
        -- Default: 1000
        priority = 1000,

        -- Override the internal highlight group name
        -- Default: 'ContextVt'
        highlight = 'CustomContextVt',

        -- Disable virtual text for given filetypes
        -- Default: { 'markdown' }
        disable_ft = { 'markdown' },

        -- Disable display of virtual text below blocks for indentation based languages like Python
        -- Default: false
        disable_virtual_lines = false,

        -- Same as above but only for spesific filetypes
        -- Default: {}
        disable_virtual_lines_ft = { },

        -- Never show virtual text for these node types
        -- Default: {}
        disable_targets = { },

        -- Same as above but only for spesific filetypes
        -- Adds to the list above instead of replacing it
        -- Default: {}
        disable_targets_ft = { },

        -- How many lines required after starting position to show virtual text
        -- Default: 1 (equals two lines total)
        min_rows = 3,

        -- Same as above but only for spesific filetypes
        -- Default: {}
        min_rows_ft = {},

        -- Custom virtual text node parser callback
        -- Default: nil
        custom_parser = nil,
        -- Custom node validator callback
        -- Default: nil
        custom_validator = nil,
        -- Custom node virtual text resolver callback
        -- Default: nil
        custom_resolver =  nil,
      })
      vim.cmd [[ au BufEnter * hi CustomContextVt guifg=#666666 ]]
    end
  }
}
