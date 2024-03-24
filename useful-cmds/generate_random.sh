# method 1
openssl rand -base64 32
# method 2
tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1
# method 3
strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo
# method 4
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32
# method 5
dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev
# method 6
< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;
