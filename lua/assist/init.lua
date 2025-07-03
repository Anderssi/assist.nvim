local M = {}

function M.setup(config)
  local utils = require('assist.utils')
  local chat = require('assist.chat')

  if not config then
    config = {}
  end

  vim.api.nvim_create_user_command('AssistPrompt', function ()
    utils.prompt(function (lines)
      local q = lines[1]
      local a = chat.ask(q)
      if a then
        vim.print(a)
      end
    end) 
  end, {})

end

return M
