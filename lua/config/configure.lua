local configure = {
  vim = {
    o = {
      filetype = "on",
      fileencodings = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1",
      updatetime = 200,
      undofile = true,
      backspace = "indent,eol,start",
      writebackup = false,
      swapfile = false,
      wrap = false,
      autochdir = false,
      autoindent = true,
      number = true,
      expandtab = true,
      tabstop = 2,
      shiftwidth = 2,
      softtabstop = 2,
      colorcolumn = "80",
      scrolloff = 9999,
      sidescrolloff = 15,
      sidescroll = 1,
      showmatch = true,
      foldlevelstart = 99,
      signcolumn = "yes",
      hidden = true, -- make buffer management can hide buffer without save.
      cursorline = true,
      mouse = "",
      winborder = "rounded",
    },
    g = {
      loaded_matchit = 1, -- disable matchit becasue ampping troubles.
    },
  },
  filetype = {
    cpp = {
      bo = {
        tabstop = 2,
        shiftwidth = 2,
        softtabstop = 2,
      },
      wo = {
        foldmethod = "expr",
        foldexpr = "nvim_treesitter#foldexpr()",
      },
    },
    c = "cpp",
    h = "cpp",
    hpp = "cpp",
    python = {
      bo = {
        tabstop = 4,
        shiftwidth = 4,
        softtabstop = 4,
      },
      wo = {
        foldmethod = "expr",
        foldexpr = "nvim_treesitter#foldexpr()",
      },
    },
    default = {
      bo = {
        tabstop = 2,
        shiftwidth = 2,
        softtabstop = 2,
      },
      wo = {
        foldmethod = "indent",
      },
    },
  },
  root_files = {
    { ".root.json", ".root" },
    { ".git" },
  },
}

return configure
