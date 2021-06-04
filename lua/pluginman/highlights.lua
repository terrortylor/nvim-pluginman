local M = {}

M.handlers = {}

function M.register_handler(handler)
  table.insert(M.handlers, handler)
end

function M.apply_highlights()
  for _, h in ipairs(M.handlers) do
	 h()
  end
end
 
return M
