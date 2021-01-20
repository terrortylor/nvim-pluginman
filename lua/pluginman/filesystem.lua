local api = vim.api

local M = {}

--- Wrapper to truthy and pretify
--@param path string - directory path to check
--@return boolean true if exists, false if not
function M.is_directory(path)
 if api.nvim_call_function('isdirectory', {path}) > 0 then
   return true
 else
   return false
 end
end

return M
