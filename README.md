# nvim-pluginman

A plugin manager for NeoVim, written in Lua. Whilst there are plenty of these things in the wild, I had rolled my own in VimL and when migrating over to Lua decided that it would be a nice to continue that trend.

# Features

* Manage vim packages from config
* Handle plugin summary using handler function (simple version built in)
* Does not require NeoVim nightly (likely a short lived feature but some of my targets I have to use whatever NeoVim is in the package manager)

# Usage

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

* [nvim-packer](https://github.com/wbthomason/packer.nvim) - This is the Rolls Royce of NeoVim plugin managers. At the time of writing this requires nightly though which I wasn't using.
