local function git_status_preview(ctx)
  if ctx.item.status:find("^[A?]") then
    return Snacks.picker.preview.file(ctx)
  end
  local cmd = { "git", "--paginate" }
  vim.list_extend(cmd, ctx.picker.opts.previewers.git.args or {})
  vim.list_extend(cmd, { "diff", "--no-ext-diff" })
  if ctx.item.status:find("[UAD][UAD]") then
    cmd[#cmd + 1] = "--cc"
  elseif ctx.item.status:sub(1, 1) ~= " " then
    cmd[#cmd + 1] = "--cached"
  end
  vim.list_extend(cmd, { "--", ctx.item.file })
  local pager = require("utils.delta").cmd({ "--" .. vim.o.background })
  return Snacks.picker.preview.cmd(cmd, ctx, {
    env = {
      GIT_PAGER = table.concat(vim.tbl_map(vim.fn.shellescape, pager), " "),
    },
  })
end

local function git_show_preview(ctx)
  local cmd = { "git", "--paginate" }
  vim.list_extend(cmd, ctx.picker.opts.previewers.git.args or {})
  vim.list_extend(cmd, { "show", "--no-ext-diff", ctx.item.commit })
  local files = ctx.item.files or ctx.item.file
  files = type(files) == "table" and files or { files }
  if #files > 0 then
    cmd[#cmd + 1] = "--"
    vim.list_extend(cmd, files)
  end
  local pager = require("utils.delta").cmd({ "--" .. vim.o.background })
  return Snacks.picker.preview.cmd(cmd, ctx, {
    env = {
      GIT_PAGER = table.concat(vim.tbl_map(vim.fn.shellescape, pager), " "),
    },
  })
end

local function git_stash_preview(ctx)
  local cmd = { "git", "--paginate" }
  vim.list_extend(cmd, ctx.picker.opts.previewers.git.args or {})
  vim.list_extend(cmd, { "stash", "show", "--patch", "--no-ext-diff", ctx.item.stash })
  local pager = require("utils.delta").cmd({ "--" .. vim.o.background })
  return Snacks.picker.preview.cmd(cmd, ctx, {
    env = {
      GIT_PAGER = table.concat(vim.tbl_map(vim.fn.shellescape, pager), " "),
    },
  })
end

local function diagnostic_without_location(item, picker)
  local display_item = vim.tbl_deep_extend("force", {}, item, {
    file = false,
    pos = false,
    item = {
      source = false,
      code = false,
    },
  })

  return Snacks.picker.format.diagnostic(display_item, picker)
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("snacks").setup({
        bigfile = { enabled = true },
        lazygit = { enabled = true },
        quickfile = { enabled = true },
        terminal = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 10000,
        },
        picker = {
          sources = {
            git_diff = {
              group = false,
              preview = "diff",
              win = {
                input = {
                  keys = {
                    ["<Tab>"] = { "focus_preview", mode = { "i", "n" } },
                  },
                },
              },
              previewers = {
                diff = {
                  style = "terminal",
                  cmd = require("utils.delta").cmd(),
                },
              },
            },
            git_status = {
              preview = git_status_preview,
              win = {
                input = {
                  keys = {
                    ["<Tab>"] = { "focus_preview", mode = { "i", "n" } },
                  },
                },
              },
              previewers = {
                diff = {
                  style = "terminal",
                  cmd = require("utils.delta").cmd(),
                },
              },
            },
            git_log = {
              preview = git_show_preview,
              previewers = {
                diff = {
                  style = "terminal",
                  cmd = require("utils.delta").cmd(),
                },
              },
            },
            git_log_file = {
              preview = git_show_preview,
              previewers = {
                diff = {
                  style = "terminal",
                  cmd = require("utils.delta").cmd(),
                },
              },
            },
            git_log_line = {
              preview = git_show_preview,
              previewers = {
                diff = {
                  style = "terminal",
                  cmd = require("utils.delta").cmd(),
                },
              },
            },
            git_stash = {
              preview = git_stash_preview,
              previewers = {
                diff = {
                  style = "terminal",
                  cmd = require("utils.delta").cmd(),
                },
              },
            },
            undo = {
              previewers = {
                diff = {
                  style = "terminal",
                  cmd = require("utils.delta").cmd(),
                },
              },
            },
            diagnostics = {
              format = diagnostic_without_location,
            },
            diagnostics_buffer = {
              format = diagnostic_without_location,
            },
          },
          win = {
            input = {
              keys = {
                ["<Tab>"] = { "focus_preview", mode = { "i", "n" } },
              },
            },
            list = {
              wo = {
                wrap = true,
                linebreak = true,
                breakindent = true,
              },
            },
            preview = {
              keys = {
                ["<Tab>"] = { "focus_input", mode = { "n", "t" } },
              },
            },
          },
          formatters = {
            file = {
              truncate = false,
            },
          },
          enable = true,
          ui_select = false,
        },
      })
      require("utils.action").register({
        name = "snacks-pickers",
        priority = -1,
        actions = function()
          return require("snacks").picker
        end,
      })
      require("utils.action").register({
        name = "snacks",
        actions = {
          lazygit = require("snacks").lazygit,
          git = require("snacks").lazygit,
        },
      })
    end,
  },
}
