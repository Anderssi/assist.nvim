local M = {}

function M.create_floating_window(opts, enter)
  if enter == nil then
    enter = false
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, enter, opts)

  return { win = win, buf = buf }
end

-- Open a prompt
function M.prompt(on_confirm)
  local width = 40
  local height = 1
  local config = {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    focusable = true,
    noautocmd = false,
    title = "Enter your input:",
  }
  local prompt_obj = M.create_floating_window(config, true)

  vim.cmd([[startinsert!]])

  vim.keymap.set("n", "<CR>", function()
    local result = vim.api.nvim_buf_get_lines(prompt_obj.buf, 0, -1, false)

    on_confirm(result)
    vim.api.nvim_win_close(prompt_obj.win, false)
  end, { buffer = prompt_obj.buf })
end

return M
