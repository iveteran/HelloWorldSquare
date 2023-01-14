# check if stdout is a terminal...
if test -t 1; then

     # see if it supports colors...
     ncolors=$(tput colors)

     if test -n "$ncolors" && test $ncolors -ge 8; then
       bold="$(tput bold)"
       underline="$(tput smul)"
       standout="$(tput smso)"
       blink=$(tput blink)
       normal="$(tput sgr0)"
       black="$(tput setaf 0)"
       red="$(tput setaf 1)"
       green="$(tput setaf 2)"
       yellow="$(tput setaf 3)"
       blue="$(tput setaf 4)"
       magenta="$(tput setaf 5)"
       cyan="$(tput setaf 6)"
       white="$(tput setaf 7)"
       lime_yellow=$(tput setaf 190)
       powder_blue=$(tput setaf 153)
     fi
fi

echo "${red}error${normal}"
echo "${green}success${normal}"
echo "${underline}underline${normal}"
echo "${standout}standout${normal}"

echo "${green}0.052${normal}"
echo "${bold}bold: ${green}2,816.00 kb${normal}"
# etc.
