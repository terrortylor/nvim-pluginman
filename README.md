![Build](https://github.com/terrortylor/nvim-pluginman/workflows/Linting%20and%20style%20checking/badge.svg)
# nvim-pluginman

A plugin manager for NeoVim, written in Lua. Whilst there are plenty of these things in the wild, I had rolled my own in VimL and when migrating over to Lua decided that it would be a nice to continue that trend.
Currently built around my requirements, so not as feature rich as other plugin managers available, limitations include that only GitHub is a supported vendor.

# Features

* Manage vim packages from config
* Built in plugin summary view, with ability to change behaviour with custom handler
  * Summary details if helpdocs exist or not
* Does not require NeoVim nightly (likely a short lived feature but some of the targets I use whatever NeoVim is available in the package manager)
* Adds plugin to runtime path after installing to prevent NeoVim restart
* Uses built in package structure as normal behaviour

# Usage

The basic usage here to require the plugin manager package, add a plugin configuration to it's configuration and then run the install method.
If a plugin doesn't exist it will be installed and the summary view is automatically displayed and any newly installed plugins are added to the runtime path to prevent a need to restart NeoVim.

```lua
local plug = require("pluginman")
plug.setup()
plug.add("plasticboy/vim-markdown")
plug.install()
```

The **add** method takes either a string or a table, if a string is provided it assumes this is the plugin path to download from, otherwise the table can take the following keys:
*  url - The URL to download a plugin from
*  package = The package directory to install the plugin under, defaults to 'plugins', See `:help packages`
*  loaded = Should the package be loaded on startup or optional, defaults to 'start'. See `:help packages` and `:help pack-add`
*  branch = The branch to download, defaults to 'master'
*  post_handler = The post handler is a function to run following the plugin being added to the runtime path

The following is an example of adding a plugin to only load when asked from a specified branch:
```lua
plug.add({url = "godlygeek/tabular", loaded = "opt", branch = "notexists"})
```

The **post_handler** is useful to run a Lua function after the plugin has been loaded, this is particularly useful to configure a plugin after it is loaded or to load a colour scheme:
```lua
plug.add({
  url = "SirVer/ultisnips",
  post_handler = function()
    vim.api.nvim_set_var("UltiSnipsEditSplit", "vertical")
  end
})
```

TODO document highlight_handler

# Bootstrapping

Add the following to your config to download and add nvim-pluginman if not already on your system.

```
local install_path = api.nvim_call_function("stdpath", {"data"}) .. "/site/pack/pluginman/start/nvim-pluginman"
if not fs.is_directory(install_path) then
  local execute = vim.api.nvim_command
  execute("!git clone https://github.com/terrortylor/nvim-pluginman " .. install_path)
  execute "packadd nvim-pluginman"
end
```

# Alternatives

* [nvim-packer](https://github.com/wbthomason/packer.nvim) - This is the Rolls Royce of NeoVim plugin managers, requires v0.5 (nightly)
* [paq-nvim](https://github.com/savq/paq-nvim) - A lightweight plugin manager, very similar to this one, but in less LOC (I'm fairly sure), requires v0.5 (nightly)
