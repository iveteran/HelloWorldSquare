# Ref: https://www.shellhacks.com/bash-colors/
#
#!/usr/bin/env bash
for i in {0..255} ; do
  printf "\x1b[38;5;${i}mcolour${i}\n"
  #printf "\e[38;5;${i}mcolour${i}\n"  # same as up
done

printf '\e[1;45;36m%s\e[0m\n' "hello world"  # bold:1, background:45, foreground:36

# echo -e '\e[31m'  # The output color is now red
#
# Reset = '\e[0m'
# Bright = '\e[1m'
# Dim = '\e[2m'
# Underscore = '\e[4m'
# Blink = '\e[5m'
# Reverse = '\e[7m'
# Hidden = '\e[8m'
# 
# FgBlack = '\e[30m'
# FgRed = '\e[31m'
# FgGreen = '\e[32m'
# FgYellow = '\e[33m'
# FgBlue = '\e[34m'
# FgMagenta = '\e[35m'
# FgCyan = '\e[36m'
# FgWhite = '\e[37m'
# 
# BgBlack = '\e[40m'
# BgRed = '\e[41m'
# BgGreen = '\e[42m'
# BgYellow = '\e[43m'
# BgBlue = '\e[44m'
# BgMagenta = '\e[45m'
# BgCyan = '\e[46m'
# BgWhite = '\e[47m'
