local function universal_keymap(key, val, cfg)
  vim.api.nvim_set_keymap("n", key, val, cfg)
  vim.api.nvim_set_keymap("i", key, val, cfg)
  vim.api.nvim_set_keymap("v", key, val, cfg)
end

local function universal_normal_keymap(key, val, cfg)
  vim.api.nvim_set_keymap("n", key, val, cfg)
  vim.api.nvim_set_keymap("i", key, "<Esc>" .. val, cfg)
  vim.api.nvim_set_keymap("v", key, "<Esc>" .. val, cfg)
end

local floaterm_group = vim.api.nvim_create_augroup("FloatermMappings", { clear = true })

-- Commands run after leaving input/visual mode, preserving the terminal's state.
-- Defaults to t/n/v; use modes to limit a mapping.
local function floaterm_mapping(key, command, cfg)
  cfg = vim.deepcopy(cfg or {})
  local modes = cfg.modes or { "t", "n", "v" }
  cfg.modes = nil
  for _, mode in ipairs(modes) do
    local prefix = ({ t = "<C-\\><C-n>", n = "", v = "<Esc>" })[mode]
    assert(prefix, "floaterm_mapping supports t, n and v modes")
    local quoted_command = string.format("%q", command):gsub("\\\n", "\\n")
    local rhs = prefix
      .. (':lua require("utils.floaterm").navigate(%s, %s, %s)<CR>'):format(
        quoted_command,
        tostring(mode == "t"),
        tostring(mode == "v")
      )
    -- FileType covers first open when BufEnter precedes filetype setup.
    vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
      group = floaterm_group,
      callback = function(event)
        if vim.bo[event.buf].filetype ~= "floaterm" then
          return
        end
        local opts = vim.tbl_extend("force", { silent = true }, cfg, { buffer = event.buf })
        vim.keymap.set(mode, key, rhs, opts)
      end,
    })
  end
end

-- Esc
universal_keymap("<C-c>", "<Esc>", {})

-- Save
universal_normal_keymap("<C-s>", ":w<CR>", { noremap = true, silent = true })

--Redo
vim.api.nvim_set_keymap("n", "U", "<C-r>", { noremap = true })

-- visual tab
vim.api.nvim_set_keymap("x", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", ">", ">gv", { noremap = true, silent = true })

-- Jump
-- Jump Prev
vim.api.nvim_set_keymap("n", "[", "<C-o>", { noremap = true })
-- Jump Next
vim.api.nvim_set_keymap("n", "]", "<Tab>", { noremap = true })

-- wintab
-- to next
universal_normal_keymap("<C-l>", ":WintabsNext<CR>", { noremap = true, silent = true })
-- to prev
universal_normal_keymap("<C-h>", ":WintabsPrevious<CR>", { noremap = true, silent = true })
-- move to next
vim.api.nvim_set_keymap("n", "L", ":WintabsMove 1<CR>", { noremap = true, silent = true })
-- move to prev
vim.api.nvim_set_keymap("n", "H", ":WintabsMove -1<CR>", { noremap = true, silent = true })
-- close
universal_normal_keymap("<C-q>", ":ConfigQuit<CR>", { noremap = true, silent = true })

-- navigator
-- up
vim.api.nvim_set_keymap("n", "K", "<C-u>", { noremap = true, silent = true })
-- down
vim.api.nvim_set_keymap("n", "J", "<C-d>", { noremap = true, silent = true })
-- lsp next
vim.api.nvim_set_keymap(
  "n",
  "<C-k>",
  ':lua require("trouble").prev{mode="sidebar_symbols", jump=true, focus=false}<CR>',
  { noremap = true, silent = true }
)
-- lsp prev
vim.api.nvim_set_keymap(
  "n",
  "<C-j>",
  ':lua require("trouble").next{mode="sidebar_symbols", jump=true, focus=false}<CR>',
  { noremap = true, silent = true }
)

-- lsp
-- hover
vim.api.nvim_set_keymap("n", "<Tab>", ":lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
-- lsp rename
vim.api.nvim_set_keymap("n", "<C-r>", ":lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })

-- picker
-- file
universal_normal_keymap("<C-o>", ':lua Snacks.picker("files")<CR>', { noremap = true, silent = true })
-- grep
universal_normal_keymap("<C-p>", ':lua Snacks.picker("grep")<CR>', { noremap = true, silent = true })
--diagnostic
universal_normal_keymap("?", ':lua Snacks.picker("diagnostics")<CR>', { noremap = true, silent = true })
--lsp_definitions
universal_normal_keymap("<S-Tab>", ':lua Snacks.picker("lsp_definitions")<CR>', { noremap = true, silent = true })
--git
universal_normal_keymap("<S-Tab>", ":lua Snacks.lazygit()<CR>", { noremap = true, silent = true })
-- all picker
universal_normal_keymap("<C-f>", ':lua require("utils.action").show()<CR>', { noremap = true, silent = true })

-- floaterm
universal_normal_keymap("<C-d>", ':lua require("utils.floaterm").toggle()<CR>', { noremap = true, silent = true })

floaterm_mapping("<C-d>", "FloatermToggle")
floaterm_mapping("<C-h>", "FloatermPrev")
floaterm_mapping("<C-l>", "FloatermNext")
floaterm_mapping("<C-q>", "FloatermKill\nFloatermToggle")
floaterm_mapping("<C-n>", "FloatermNew")
vim.api.nvim_set_keymap("t", "<C-f>", "<C-\\><C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-D>", "<C-d>", { noremap = true, silent = true })
