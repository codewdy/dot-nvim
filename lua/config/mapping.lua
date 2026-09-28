local function universal_keymap(key, val, cfg)
  vim.api.nvim_set_keymap('n', key, val, cfg)
  vim.api.nvim_set_keymap('i', key, val, cfg)
  vim.api.nvim_set_keymap('v', key, val, cfg)
end

local function universal_normal_keymap(key, val, cfg)
  vim.api.nvim_set_keymap('n', key, val, cfg)
  vim.api.nvim_set_keymap('i', key, '<Esc>' .. val, cfg)
  vim.api.nvim_set_keymap('v', key, '<Esc>' .. val, cfg)
end

-- Esc
universal_keymap("<C-c>", "<Esc>", {})

-- Save
universal_normal_keymap("<C-s>", ":w<CR>", { noremap = true, silent = true })

--Redo
vim.api.nvim_set_keymap('n', "U", "<C-r>", { noremap = true })

-- Jump
-- Jump Prev
vim.api.nvim_set_keymap('n', "[", '<C-o>', { noremap = true })
-- Jump Next
vim.api.nvim_set_keymap('n', "]", '<Tab>', { noremap = true })

-- wintab
-- to next
universal_normal_keymap("<C-l>", ':WintabsNext<CR>', { noremap = true, silent = true })
-- to prev
universal_normal_keymap("<C-h>", ':WintabsPrevious<CR>', { noremap = true, silent = true })
-- move to next
vim.api.nvim_set_keymap('n', "L", ':WintabsMove 1<CR>', { noremap = true, silent = true })
-- move to prev
vim.api.nvim_set_keymap('n', "H", ':WintabsMove -1<CR>', { noremap = true, silent = true })
-- close
universal_normal_keymap("<C-q>", ':WintabsClose<CR>', { noremap = true, silent = true })

-- navigator
-- up
vim.api.nvim_set_keymap('n', "K", '<C-u>', { noremap = true, silent = true })
-- down
vim.api.nvim_set_keymap('n', "J", '<C-d>', { noremap = true, silent = true })
-- lsp next
vim.api.nvim_set_keymap('n', "<C-k>", ':lua require("trouble").prev{mode="sidebar_symbols", jump=true, focus=false}<CR>', { noremap = true, silent = true })
-- lsp prev
vim.api.nvim_set_keymap('n', "<C-j>", ':lua require("trouble").next{mode="sidebar_symbols", jump=true, focus=false}<CR>', { noremap = true, silent = true })

-- lsp
-- hover
vim.api.nvim_set_keymap('n', "<Tab>", ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
-- lsp rename
vim.api.nvim_set_keymap('n', "<C-r>", ':lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })

-- picker
-- file
universal_normal_keymap("<C-o>", ':lua Snacks.picker("files")<CR>', { noremap = true, silent = true })
-- grep
universal_normal_keymap("<C-p>", ':lua Snacks.picker("grep")<CR>', { noremap = true, silent = true })
--symbols
universal_normal_keymap("<C-d>", ':lua Snacks.picker("lsp_symbols")<CR>', { noremap = true, silent = true })
--diagnostic
universal_normal_keymap("?", ':lua Snacks.picker("diagnostics")<CR>', { noremap = true, silent = true })
-- all picker
universal_normal_keymap("<C-f>", ':lua require("utils.picker").show()<CR>', { noremap = true, silent = true })

-- floaterm
-- toggle
universal_normal_keymap("<C-e>", ':FloatermToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', "<C-e>", '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', "<C-n>", '<C-\\><C-n>:FloatermNew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', "<C-h>", '<C-\\><C-n>:FloatermPrev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', "<C-l>", '<C-\\><C-n>:FloatermNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', "<C-v>", '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', "<C-q>", '<C-\\><C-n>:FloatermKill<CR>:FloatermToggle<CR>', { noremap = true, silent = true })

