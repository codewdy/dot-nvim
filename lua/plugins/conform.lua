return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- lua
        lua = { "stylua" },
        -- c, cpp
        c = { "clang-format" },
        cpp = { "clang-format" },
        -- python
        python = { "ruff_format" },
        -- javascript, typescript
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        -- json, jsonc
        json = { "prettier" },
        jsonc = { "prettier" },
        -- yaml
        yaml = { "prettier" },
        ["yaml.docker-compose"] = { "prettier" },
        -- toml
        toml = { "tombi" },
        -- html
        html = { "prettier" },
        -- css, scss, less
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        -- bash, sh
        bash = { "shfmt" },
        sh = { "shfmt" },
        -- markdown, mdx
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        -- cmake
        cmake = { "cmake_format" },
      },
      -- Use LSP formatting for filetypes without an available formatter.
      default_format_opts = {
        lsp_format = "fallback",
        timeout_ms = 2000,
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
    },
    config = function(_, opts)
      local conform = require("conform")
      conform.setup(opts)

      vim.api.nvim_create_user_command("Format", function(args)
        local range
        if args.range > 0 then
          local line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, #line },
          }
        end
        conform.format({ range = range })
      end, { range = true, desc = "Format buffer or selection with Conform" })

      require("utils.action").register({
        name = "conform",
        actions = { format = require("conform").format },
      })
    end,
  },
}
