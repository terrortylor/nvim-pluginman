local api = vim.api

local M = {}

function M.add_to_runtimepath(path, name)
  api.nvim_command("set runtimepath^=" .. path)
  api.nvim_command("packadd " .. name)
end

return M
