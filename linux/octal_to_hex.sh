# Convert octal to hexa ##
echo "obase=16; ibase=8; octal-number-here" | bc
 
## convert base 8 (octal) number 17 to hexadecimal ##
echo "obase=16; ibase=8; 17" | bc

# Convert hexa to octal ##
echo "obase=8; ibase=16; hex-number-here" | bc

## convert base 16 (hex) number 10 to octal ##
echo "obase=8; ibase=16; 100" | bc
