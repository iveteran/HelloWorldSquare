#!/bin/bash

for i in {1..254}
do
    ip=192.168.0.$i
    echo trying host $ip
    nc -w 2 $ip 22 </dev/null
    echo result $?
done
