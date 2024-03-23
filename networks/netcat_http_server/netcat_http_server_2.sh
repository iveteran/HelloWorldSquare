#!/bin/env bash
#
trap handle_ctrl_c SIGINT
handle_ctrl_c () {
    exit 1
}

LISTEN_PORT=8088
echo "Listens on ${LISTEN_PORT} ..."
while true; do cat index.html | nc -l -p ${LISTEN_PORT}; done
