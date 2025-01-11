#!/bin/sh

findpid=$1

known_windows=$(xwininfo -root -children|sed -e 's/^ *//'|grep -E "^0x"|awk '{ print $1 }')

for id in ${known_windows}
do
    xp=$(xprop -id $id _NET_WM_PID)
    if test $? -eq 0; then
        pid=$(xprop -id $id _NET_WM_PID|cut -d'=' -f2|tr -d ' ')

        if test "x${pid}" = x${findpid}
        then
            echo "Windows Id: $id"
        fi
    fi
done

