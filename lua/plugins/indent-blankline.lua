return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = function()
    vim.opt.termguicolors = true

    local hooks = require("ibl.hooks")

    local indent_highlights = {
      "IblRainbowDarkRed",
      "IblRainbowDarkOrange",
      "IblRainbowDarkYellow",
      "IblRainbowDarkGreen",
      "IblRainbowDarkCyan",
      "IblRainbowDarkBlue",
      "IblRainbowDarkViolet",
    }

    local scope_highlights = {
      "IblRainbowBrightRed",
      "IblRainbowBrightOrange",
      "IblRainbowBrightYellow",
      "IblRainbowBrightGreen",
      "IblRainbowBrightCyan",
      "IblRainbowBrightBlue",
      "IblRainbowBrightViolet",
    }

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- Indent guides outside the selected scope use dim rainbow colors.
      vim.api.nvim_set_hl(0, "IblRainbowDarkRed", { fg = "#4A252C" })
      vim.api.nvim_set_hl(0, "IblRainbowDarkOrange", { fg = "#4A3426" })
      vim.api.nvim_set_hl(0, "IblRainbowDarkYellow", { fg = "#474225" })
      vim.api.nvim_set_hl(0, "IblRainbowDarkGreen", { fg = "#29452D" })
      vim.api.nvim_set_hl(0, "IblRainbowDarkCyan", { fg = "#24434A" })
      vim.api.nvim_set_hl(0, "IblRainbowDarkBlue", { fg = "#283B50" })
      vim.api.nvim_set_hl(0, "IblRainbowDarkViolet", { fg = "#402C4D" })

      -- The selected scope uses the matching bright rainbow color.
      vim.api.nvim_set_hl(0, "IblRainbowBrightRed", { fg = "#FF6B7A" })
      vim.api.nvim_set_hl(0, "IblRainbowBrightOrange", { fg = "#FFB86C" })
      vim.api.nvim_set_hl(0, "IblRainbowBrightYellow", { fg = "#F1FA8C" })
      vim.api.nvim_set_hl(0, "IblRainbowBrightGreen", { fg = "#69E079" })
      vim.api.nvim_set_hl(0, "IblRainbowBrightCyan", { fg = "#56D6E4" })
      vim.api.nvim_set_hl(0, "IblRainbowBrightBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "IblRainbowBrightViolet", { fg = "#C678DD" })
    end)

    return {
      indent = {
        char = "▏",
        highlight = indent_highlights,
      },
      scope = {
        enabled = true,
        char = "▏",
        highlight = scope_highlights,
        show_start = true,
        show_end = true,
      },
    }
  end,
}
