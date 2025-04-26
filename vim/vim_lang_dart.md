# Vim as a Flutter IDE
[Refer](https://dev.to/tavanarad/vim-as-a-flutter-ide-4p16)

## Plugins
Vundle:
  Plugin 'dart-lang/dart-vim-plugin'
  #Plugin 'natebosch/vim-lsc'
  #Plugin 'natebosch/vim-lsc-dart'
vim-plug:
  Plug 'natebosch/vim-lsc'
  Plug 'natebosch/vim-lsc-dart'

## Options
```
let g:lsc_auto_map = v:true
```

## Keymaps
The default keymaps of vim-lsc are:
```
'GoToDefinition': <C-]>,
'GoToDefinitionSplit': [<C-W>], <C-W><C-]>],
'FindReferences': gr,
'NextReference': <C-n>,
'PreviousReference': <C-p>,
'FindImplementations': gI,
'FindCodeActions': ga,
'Rename': gR,
'DocumentSymbol': go,
'WorkspaceSymbol': gS,
'SignatureHelp': gm,
```
