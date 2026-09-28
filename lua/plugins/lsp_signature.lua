return {
    {
        'ray-x/lsp_signature.nvim',
        config = function()
            require'lsp_signature'.setup{
                bind = true,
                doc_lines = 0,
                floating_window = true,
                floating_window_above_cur_line = true,
                fix_pos = false,
                hint_enable = false,
                max_height = 12,
                max_width = 120,
                handler_opts = {
                    border = "single"
                },
                always_trigger = true,
                auto_close_after = nil,
                extra_trigger_chars = {},
                zindex = 200,
                padding = '',
                transparency = nil,
                shadow_blend = 36,
                shadow_guibg = 'Black',
                timer_interval = 200,
                toggle_key = '<C-z>'
            }
        end
    }
}
