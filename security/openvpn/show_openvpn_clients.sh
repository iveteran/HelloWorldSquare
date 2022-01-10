#!/bin/env bash

STATUS_LOG_FILE=/var/log/openvpn/openvpn-status.log
if [ -e $STATUS_LOG_FILE ]
then
    grep "CLIENT_LIST" $STATUS_LOG_FILE
else
    echo Maybe the OpenVPN service does not exist or not running
fi
