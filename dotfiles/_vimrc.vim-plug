" Refer:
"   https://github.com/junegunn/vim-plug
"
" Install:
"   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" Install Plugins:
"   PlugInstall
"
" Commands:
"   PlugInstall [name ...] [#threads]	Install plugins
"   PlugUpdate [name ...] [#threads]	Install or update plugins
"   PlugClean[!]	                    Remove unlisted plugins (bang version will clean without prompt)
"   PlugUpgrade	                      Upgrade vim-plug itself
"   PlugStatus	                      Check the status of plugins
"   PlugDiff	                        Examine changes from the previous update and the pending changes
"   PlugSnapshot[!] [output path]	    Generate script for restoring the current snapshot of the plugins
"
" Install all plugins:
"   PlugInstall
"
" -- begin: vim-plug --
call plug#begin()
 " Your vim plugins here
  Plug 'wuelnerdotexe/vim-astro'
  Plug 'phelipetls/vim-hugo'
  "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'editorconfig/editorconfig-vim'

  "Plug 'prabirshrestha/async.vim'
  "Plug 'prabirshrestha/asyncomplete.vim'

  " Vim LSP
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'

  " LSP for Go language
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

  " LSP For Dart language
  "  Refer: https://dev.to/tavanarad/vim-as-a-flutter-ide-4p16
  Plug 'dart-lang/dart-vim-plugin'
  Plug 'natebosch/vim-lsc'
  Plug 'natebosch/vim-lsc-dart'
call plug#end()
" -- end: vim-plug --

" Enable vim-astro
let g:astro_typescript = 'enable'
"let g:astro_stylus = 'enable'

" vim-lsc options
let g:lsc_auto_map = v:true
