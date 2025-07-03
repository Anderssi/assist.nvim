local M = {}

local function create_floating_window(opts, enter)
  if enter == nil then
    enter = false
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, enter, opts)

  return { win = win, buf = buf }
end

local function visual_selection()
  return vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
end

function M.setup(config)
  if not config then
    config = {}
  end

  vim.api.nvim_create_user_command("AssistCall", function (first, second)
    vim.print(second or "asdfasdf")
  end, {})

  vim.api.nvim_create_user_command("AssistInline", function ()
    local dialog_group = vim.api.nvim_create_augroup('Assist_dialog', {})

    -- Question dialog
    local dialog = create_floating_window({
      relative = 'win',
      col = math.floor((vim.o.columns - 80) / 2),
      row = math.floor((vim.o.lines - 1) / 2),
      width = 80,
      height = 1,
      title = "Ask Assistant",
      border = "rounded",
      style = "minimal",
    }, true)

    vim.api.nvim_create_autocmd("BufLeave", { 
      command = "AssistCall", 
      group = dialog_group,
      buffer = dialog.buf,
    })
    vim.keymap.set('n', '<CR>', function ()

    end, {})

    vim.keymap.set('n', 'q', function ()
      vim.api.nvim_win_close(dialog.win, false)
    end, { buffer = dialog.buf })

  end, { range = true }) -- allowes selection range
end

return M
