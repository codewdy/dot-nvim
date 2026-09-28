return {
    {
        'https://codeberg.org/andyg/leap.nvim',
        config = function()
            require("leap").opts.vim_opts['go.ignorecase'] = true
            vim.keymap.set({ 'n', 'x', 'o' }, 's',  '<Plug>(leap)')
        end
    }
}
