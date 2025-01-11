# VIM tips

## Navigating HTML tags in Vim
1. You can jump between tags using visual operators, in example:
Place the cursor on the tag.
Enter visual mode by pressing v.
Select the outer tag block by pressing a+t or i+t for inner tag block.
Your cursor should jump forward to the matching closing html/xml tag. To jump backwards from closing tag, press o or O to jump to opposite tag.

2. See more help at :help visual-operators or :help v_it:
at: a <tag> </tag> block (with tags)
it: inner <tag> </tag> block

Refer: https://stackoverflow.com/questions/6270396/navigating-html-tags-in-vim

## Add a string to the end of each line in Vim
Even shorter than the :search command:
:%norm A*

This is what it means:
 %       = for every line
 norm    = type the following commands
 A*      = append '*' to the end of current line


## Search and replace in all opened files(buffers)
bufdo! %s/string/replacement/g

bufdo : action on all buffers .
! : force
s : replacing
g : global

Related commands:
:tabdo (all tabs)
:windo (all windows in the current tab)
:bufdo (all buffers, i.e. all those listed with the :ls command)
:argdo (all files in argument list)
:cdo (all files listed in the quickfix list)
