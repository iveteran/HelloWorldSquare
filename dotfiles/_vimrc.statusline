" Ref: https://jdhao.github.io/2019/11/03/vim_custom_statusline/

" 防止光标位置查询污染输出
set t_RV=

let g:currentmode={
      \ 'n'  : 'NORMAL',
      \ 'v'  : 'VISUAL',
      \ 'V'  : 'V·Line',
      \ "\<C-V>" : 'V·Block',
      \ 'i'  : 'INSERT',
      \ 'R'  : 'REPLACE',
      \ 'Rv' : 'V·Replace',
      \ 'c'  : 'Command',
      \}

"function GitBranch()
"    "return trim(system('git branch --show-current 2>/dev/null'))
"    "let b:value = trim(system('git branch --show-current 2>/dev/null'))
"    " 使用环境变量禁用终端提示，并重定向错误输出
"    let cmd = 'GIT_TERMINAL_PROMPT=0 git branch --show-current 2>/dev/null'
"    let b:value = trim(system(cmd))
"    if v:shell_error == 0 && strlen(b:value) > 0
"        return printf(' [ %s] ', b:value)  " wrap with [ ]
"    else
"        return ''
"    endif
"endfunction
"
"function InitGitBranch()
"    let b:git_branch = GitBranch()
"endfunction
"
"" Initialize b:git_branch
"augroup GitBranchInit
"    autocmd!
"    "autocmd VimEnter,BufNewFile,BufReadPre * call InitGitBranch()
"    " 延迟初始化避免终端查询问题
"    autocmd VimEnter * call timer_start(50, {-> InitGitBranch()})
"    " 确保所有缓冲区都有这个变量
"    autocmd BufNewFile,BufReadPost,BufEnter * call InitGitBranch()
"augroup END

" Git branch display for statusline (cached version)
function! GitBranch()
  if !exists('b:git_branch')
    let branch = system("git branch --show-current 2>/dev/null | tr -d '\n'")
    let b:git_branch = strlen(branch) > 0 ? ' [' . branch . '] ' : ''
  endif
  return b:git_branch
endfunction
" Refresh git branch when entering buffer
autocmd BufEnter * unlet! b:git_branch

"augroup Gitget
"    autocmd!
"    " Run on BufReadPre so it happens before the LSP integration runs
"    autocmd BufReadPre * let b:git_branch = GitBranch()
"    " Keep the BufEnter for files that might be created without going through BufRead
"    autocmd BufEnter * let b:git_branch = GitBranch()
"augroup END

hi statusline ctermbg=240
hi statusline ctermfg=232
"hi statusline ctermfg=black

" define highlight statusline groups
hi User1 ctermfg=0 ctermbg=red
"hi User1 ctermfg=0 ctermbg=brown
hi User2 ctermfg=0 ctermbg=magenta
hi User3 ctermfg=0 ctermbg=blue
hi User4 ctermfg=0 ctermbg=lightgreen
hi User5 ctermfg=0 ctermbg=yellow
hi User6 ctermfg=yellow ctermbg=240

"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

set statusline=
"set statusline+=%1*  " equal to below line
set statusline+=%#User1#
set statusline+=\ %{g:currentmode[mode()]}\ 
set statusline+=%#User6#
"set statusline+=%{b:git_branch}
"set statusline+=%{get(b:,'git_branch','')} " 使用 get() 函数安全地获取变量值
set statusline+=%{GitBranch()}
set statusline+=%*
set statusline+=\ %f%m%r%h%w  " %f: filename, %m: modified flag, %r: readonly flag, %h: help buffer flag, %w: preview window flag
set statusline+=%= " Separation point between left and right aligned items
"set statusline+=%5*
"set statusline+=[ascii=\%03.3b]
"set statusline+=[hex=\%02.2B]
if (&filetype != '')
    set statusline+=%#User2#
    set statusline+=\ %y\ 
endif
set statusline+=%#User3#
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}[%{&ff}]\  " filetype encoding[format]
"set statusline+=%4*  " equal to below line
set statusline+=%#User4#
set statusline+=\ %l,%v\ %P\/%L\  " line:column percent total
