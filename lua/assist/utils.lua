local M = {}

local function create_floating_window(opts, enter)
  if enter == nil then
    enter = false
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, enter, opts)

  return { win = win, buf = buf }
end

function M.prompt(on_confirm)
  local config = {
    relative = 'editor',
    row = 1,
    col = 10,
    width = 40,
    height = 5,
    style = 'minimal',
    border = 'rounded',
    focusable = true,
    noautocmd = false,
    title="Enter your input:",
  }
  local prompt_obj = create_floating_window(config, true)

  vim.cmd([[startinsert!]])    -- Switch to insert mode in the new window

  vim.keymap.set('n', '<CR>', function ()
    local result = vim.api.nvim_buf_get_lines(prompt_obj.buf, 0, -1, false)
    on_confirm(result)
    vim.api.nvim_win_close(prompt_obj.win, false)
  end, { buffer = prompt_obj.buf })
end

return M

