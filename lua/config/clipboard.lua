local osc52 = require("vim.ui.clipboard.osc52")

vim.g.clipboard = {
  name = "tmux-and-osc52",
  copy = {
    ["*"] = { "tmux", "load-buffer", "-" },
    ["+"] = osc52.copy("+"),
  },
  paste = {
    ["*"] = { "tmux", "save-buffer", "-" },
    ["+"] = osc52.paste("+"),
  },
  cache_enabled = 0,
}

vim.opt.clipboard = "unnamed"

