local function diagnostic_without_location(item, picker)
  local display_item = vim.tbl_deep_extend("force", {}, item, {
    file = false,
    pos = false,
    item = {
      source = false,
      code = false
    }
  })

  return Snacks.picker.format.diagnostic(display_item, picker)
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("snacks").setup{
        bigfile = { enabled = true },
        lazygit = { enabled = true },
        quickfile = { enabled = true },
        terminal = { enable = true },
        picker = {
          sources = {
            diagnostics = {
              format = diagnostic_without_location,
            },
            diagnostics_buffer = {
              format = diagnostic_without_location,
            },
          },
          win = {
            list = {
              wo = {
                wrap = true,
                linebreak = true,
                breakindent = true,
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
      }
    end
  }
}
