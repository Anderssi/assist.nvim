local M = {}

M.messages = {
  {
    role = "system",
    content = "You are a code and math specialist, All your answers should be in markdown. Only provide code examples and no commentary",
  }
}

function M.setup(config)
  
end

function clean_string(str)
  str = str.gsub(str, '\'', '')
  str = str.gsub(str, '\"', '')
  return str
end

function add_message(role, value)
  local message = {
    role = role,
    content = clean_string(value)
  }
  table.insert(M.messages, message)
end 

function M.ask(question)
  add_message("user", question)
  
  local payload = vim.json.encode({
    model = "deepseek-coder-v2:16b",
    messages = M.messages,
    stream = false,
  })
  local cmd = string.format("curl -s 127.0.0.1:11434/api/chat -d '%s'", payload)
  local response = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    vim.print("Error running command" .. cmd)
    return nil
  end

  local data = vim.json.decode(response)
  local answer = clean_string(data.message.content)
  add_message("assistant", answer)
  return answer
end

return M
