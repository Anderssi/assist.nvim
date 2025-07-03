local M = {}

function M.setup(config)
  local utils = require('assist.utils')

  if not config then
    config = {}
  end

  vim.api.nvim_create_user_command('AssistPrompt', function ()
    utils.prompt(function (lines)
      local value = lines[1]
      vim.print(value)
    end) 
  end, {})

end

return M
