# blinking
echo -e "\033[5mBlinking\033[0m"

# have blinking and color
echo -e "\033[33;5mBlinking and yellow\033[0m"
echo -e "\033[31;5mBlinking and red\033[0m"


# Refer: https://stackoverflow.com/questions/17439482/how-to-make-a-text-blink-in-shell-script
# Blinking text
tput blink
# Revert characteristics
tput sgr0
# For example
tput blink; echo This is blinking text; tput sgr0
# Or
blink=$(tput blink) noblink=$(tput sgr0)
printf '%s\n' "Here we go: ${blink}this blinks${noblink} and this is steady"
