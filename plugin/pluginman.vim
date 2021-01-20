if exists('g:loaded_pluginman') | finish | endif

" command to run our plugin
command! -nargs=0 PluginsStatus lua require('pluginman').open_summary_draw()

let g:loaded_pluginman = 1
