# fzf
# Install: apt install fzf
# Set up fzf key bindings and fuzzy completion
# Official: https://github.com/junegunn/fzf/
# Guide: https://thevaluable.dev/practical-guide-fzf-example/
#eval "$(fzf --bash)"

_find_exclude_dir_opt='-not -path "*__pycache__*" -not -path "*node_modules*" -not -path "*target*" -not -path "*/\.*"'
find_in_dir() {
    local dir=$1
    find $dir ${_find_exclude_dir_opt}  # Error: this method of using variable is not avaiable
}
find_files() {
    local dir=$1
    #find $dir -type f ${_find_exclude_dir_opt}
    find $dir -type f -not -path "*__pycache__*" -not -path "*node_modules*" -not -path "*target*" -not -path "*/\.*"
}
find_dirs() {
    local dir=$1
    #find $dir -type d ${_find_exclude_dir_opt}
    find $dir -type d -not -path "*__pycache__*" -not -path "*node_modules*" -not -path "*target*" -not -path "*/\.*"
}

#export FZF_DEFAULT_COMMAND='find_in_dir .'
#export FZF_DEFAULT_OPTS='--margin=3% --border=double --color="dark,fg:magenta"'
export FZF_DEFAULT_OPTS="\
    --bind='alt-p:toggle-preview' \
    --bind='ctrl-j:preview-down' \
    --bind='ctrl-k:preview-up' \
    --margin=3% \
    --border \
    --color='dark,fg:magenta' \
    "

# Set FZF_ALT_C_COMMAND to override the default command
#export FZF_ALT_C_COMMAND='cd'
# Set FZF_ALT_C_OPTS to pass additional options

alias find_project_files='find_files ~/projects'
alias find_project_dirs='find_dirs ~/projects'
alias find_cwd_files='find_files .'
alias find_cwd_dirs='find_dirs .'

alias fzf_file_preview_and_edit_on_new_tmux_window='fzf --preview "batcat --color=always {}" --bind "enter:become(tmux neww -n 'fzf-vim' vim {})"'
alias fzf_file_edit='fzf --bind "enter:become(vim {})"'
alias fzf_dir_preview='fzf --preview "tree -C {}"'

alias fzf_project_files='find_project_files | fzf_file_preview_and_edit_on_new_tmux_window'
alias fzf_cwd_files='find_cwd_files | fzf_file_preview_and_edit_on_new_tmux_window'
alias fzf_project_files_tmux='tmux popup -w 60% -h 60% "find_project_files | fzf_file_edit"'
alias fzf_project_dir='cd $(find_project_dirs | fzf_dir_preview)'
alias fzf_cwd_dir='cd $(find_cwd_dirs | fzf_dir_preview)'
alias vim-find='vim $(fzf-tmux -p 60%,60%)'
alias vim-find-bt='vim $(fzf-tmux)'

fzf-dir() {
    local target_dir='.'  # default
    if [[ $# > 0 ]]; then
        target_dir=$1
    fi
    find_files $target_dir | fzf_file_preview_and_edit_on_new_tmux_window
}

fzf-jobs() {
    # depend on pcregrep, apt install pcregrep
    #
    #kill -STOP $FG_PID  # suspend foreground process
    # fg `jobs | fzf --height=30% --header=*Jobs* --bind='enter:become(echo {} | pcregrep -o1 "\[([0-9])\]")'`
    job_id=`jobs | fzf --height=30% --header=*Jobs* --bind='enter:become(echo {} | pcregrep -o1 "\[([0-9])\]")'`
    if [ $? == 0 ]; then
        fg $job_id
    fi
}

fzf-ripgrep() {
    # $(echo {} | cut -d: -f 1) -> get filename
    # $(echo {} | cut -d: -f 2) -> get line number of matched for searching keyword
    rg -n . | fzf --preview 'batcat --color=always -H $(echo {} | cut -d: -f 2) $(echo {} | cut -d: -f 1)' \
        --bind 'enter:become(batcat $(echo {} | cut -d: -f 1)),ctrl-e:become(vim $(echo {} | cut -d: -f 1))'
}

# NOTE: Ctrl-j already has been binded to Bash 'accept-line'
#       Ctrl-i already has been binded to Bash 'completion'
#bind '"\e[24~":"fzf-jobs\n"'  # bind F12 to run fzf-jobs
bind -x '"\C-o":fzf-jobs'     # bind Ctrl-o to run fzf-jobs
bind -x '"\C-f":fzf-ripgrep'  # bind Ctrl-f to run fzf-ripgrep, that search file content of current directory

# Shell Integration
#  refer: https://thevaluable.dev/fzf-shell-integration/
source /usr/share/doc/fzf/examples/key-bindings.bash
# Keystroke	Description
# CTRL-t	Fuzzy find all files and subdirectories of the working directory, and output the selection to STDOUT.
# ALT-c	    Fuzzy find all subdirectories of the working directory, and run the command “cd” with the output as argument.
# CTRL-r	Fuzzy find through your shell history, and output the selection to STDOUT.

# Completion Using fzf
source /usr/share/bash-completion/completions/fzf
# vim **<TAB>
# cd **<TAB>
# cd public**<TAB>
