#!/bin/bash
# refer: https://github.com/junegunn/fzf/discussions/2528

export FZF_DEFAULT_COMMAND="rg -uu \
    --files \
    -H"

export FZF_ALT_COMMAND="fd -uu -t f"

export FZF_MOVEMENT="\
    --bind='alt-p:toggle-preview' \
    --bind='ctrl-k:preview-up' \
    --bind='ctrl-j:preview-down' \
    --bind='ctrl-f:preview-page-up' \
    --bind='ctrl-b:preview-page-down' \
    --bind='ctrl-u:half-page-up+refresh-preview' \
    --bind='ctrl-d:half-page-down+refresh-preview' \
    --bind='alt-u:page-up+refresh-preview' \
    --bind='alt-d:page-down+refresh-preview' \
    --bind='alt-y:yank' \
    --bind='ctrl-y:kill-line' \
    --bind='alt-g:ignore' \
    --bind='ctrl-g:top' \
    --bind='alt-a:toggle-all' \
    --bind='alt-s:toggle-sort' \
    --bind='alt-h:backward-char+refresh-preview' \
    --bind='alt-l:forward-char+refresh-preview' \
    --bind='ctrl-l:clear-screen'"

export FZF_DEFAULT_OPTS="$FZF_MOVEMENT \
    --bind='ctrl-h:execute(man {})' \
    --bind='ctrl-v:execute(bat {})' \
    --tiebreak='length,index' \
    --preview-window 'right:100:wrap:cycle' \
    --border \
    --color='dark,fg:magenta' \
    --margin=3% \
    --height=100 \
    --exact \
    --info='inline' \
    --cycle \
    --multi \
    --ansi"

#if [[ -z "$DISPLAY" ]]; then
#    FZF_DEFAULT_OPTS += "\
#        --color=info:1 \
#        --color=prompt:2 \
#        --color=pointer:3 \
#        --color=hl+:4 \
#        --color=marker:6 \
#        --color=spinner:7 \
#        --color=header:8 \
#        --color=border:9 \
#        --color=hl:122 \
#        --color=preview-fg:11 \
#        --color=fg:13 \
#        --color=fg+:14"
#fi
