-- TODO is this luacheck required any more
-- luacheck: globals Plugin
require("pluginman.plugin")
local clone = require('pluginman.clone')
local view = require('pluginman.view')
local fs = require("pluginman.filesystem")
local highlights = require("pluginman.highlights")

-- TODO handle this better
local api = vim.api
local config_path = api.nvim_call_function('stdpath', {'data'})

local M = {}

M.opts = {
  view_summary_handler = nil
}

local plugins = {}

function M.add(opts)
  local plugin
  if type(opts) == 'string' then
    plugin = Plugin:new(config_path, {url = opts})
  elseif type(opts) == 'table' then
    plugin = Plugin:new(config_path, opts)
  end
  table.insert(plugins, plugin)
end

function M.check_plugin_status(plugin)
  if fs.is_directory(plugin:get_install_path()) then
    if plugin.loaded == "start" then
      api.nvim_command("packadd " .. plugin:get_name())
    end
    plugin:set_installed(true)
    if fs.is_directory(plugin:get_docs_path()) then
      plugin:set_docs(true)
    else
      plugin:set_docs(false)
    end
    return false
  else
    return true
  end
end

-- TODO add tests
function M.install()
  local require_install = false
  -- check if any plugins or docs need generating
  -- run post_handler for installed plugins
  for _,plug in pairs(plugins) do
    local missing = M.check_plugin_status(plug)
    if missing then
      require_install = true
    -- else
    --   -- if post handler func exist run it
    --   if plug.post_handler then
    --     print("post handler found")
    --     plug.post_handler()
    --   end
    end
  end

  -- install/clone if required
  if require_install then
    M.open_summary_draw()
    local view_cb = function()
      view.summary(M.opts.view_summary_handler)
    end

    for _,plug in pairs(plugins) do
      clone.get(plug, view_cb)
    end
  end

  for _,plug in pairs(plugins) do
    if plug.installed then
      -- if post handler func exist run it
      if plug.post_handler then
        plug.post_handler()
      end

      -- if highlight handler func exist run it
      if plug.highlight_handler then
        highlights.register_handler(plug.highlight_handler)
      end
    end
  end
end

-- TODO add tests
-- TODO rename now composable view
function M.open_summary_draw()
  view.set_plugins(plugins)
  view.summary(M.opts.view_summary_handler)
end

function M.setup(opts)
  M.opts = vim.tbl_extend('force', M.opts, opts or {})

  -- TODO multi line string
  vim.cmd('augroup plugin_highlights')
  vim.cmd('autocmd!')
  vim.cmd("autocmd colorscheme * lua require('pluginman.highlights').apply_highlights()")
  vim.cmd('augroup END')
end


if _TEST then
  -- setup test alias for private elements using a modified name
  M._plugins = function() return plugins end
  M._reset = function() plugins = {} end
end

return M
