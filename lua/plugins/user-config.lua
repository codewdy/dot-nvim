return {
  {
    "user-config",
    virtual = true,
    priority = 1000,
    config = function()
      require("config.base")
      require("config.clipboard")
      require("config.mapping")
      require("config.actions")
      require("config.fold")
      require("lsp_conf")
    end,
  },
}
