" See: helloworld/vim/YouCompleteMe.txt
" YouCompleteMe options the default <leader> is '\'

:set timeoutlen=3000  " wait timeout(unit: ms) of <leader>, the default value is 1000 ms
nnoremap <leader>gf :YcmCompleter GoToInclude<CR>
nnoremap <leader>gt :YcmCompleter GoTo<CR>
"nnoremap <leader>gv :YcmCompleter GoToDeclaration<CR>
"nnoremap <leader>gv :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>rn :exec ":YcmCompleter RefactorRename ".input("New name: ")<CR>
nnoremap <C-]> :YcmCompleter GoTo<CR>
nnoremap <C-t> <C-o>

" Disable syntax checker
let g:ycm_show_diagnostics_ui = 0

" Disable hint popup
let g:ycm_auto_hover=''
