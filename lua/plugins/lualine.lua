return {
    {
        'hoob3rt/lualine.nvim',
        dependencies = {
          "Isrothy/lualine-diagnostic-message",
        },
        config = function()
        require'lualine'.setup {
          options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {},
            always_divide_middle = true,
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {
              {
                'diagnostics',
                sources = {'nvim_diagnostic'}
              }
            },
            lualine_c = { "diagnostic-message" },
            lualine_x = {},
            lualine_y = {
              {
                'filename',
                file_status = true,
                path = 2,
                shorting_target = 40
              }
            },
            lualine_z = {
              {
                function ()
                  return os.date("%H:%M")
                end
              }
            }
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
          },
          tabline = {},
          extensions = {}
        }
        end
    }
}
