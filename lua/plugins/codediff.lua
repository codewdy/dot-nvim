return {
  "esmuellert/codediff.nvim",
  config = function() 
    require("codediff").setup{
      diff = {
        layout = "inline",
      },
    }
    local function code_diff()
      vim.cmd [[ CodeDiff ]]
    end
    local function code_diff_history()
      vim.cmd [[ CodeDiff history ]]
    end
    require("utils.action").register{
      name = "code-diff",
      actions = {
        code_diff = code_diff,
        git_diff = code_diff,
        git_diff_history = code_diff_history,
      }
    }
  end,
}
