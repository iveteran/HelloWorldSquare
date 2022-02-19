#!/bin/sh

LISTEN_PORT=8088
BACKEND_HOST=localhost
BACKEND_PORT=4000
FIFO_NAME=nc_reverse_proxy_fifo

echo "Listens on ${LISTEN_PORT} and redirects to ${BACKEND_HOST}:${BACKEND_PORT}, Runs until Ctrl-c."

trap on_sigint SIGINT
on_sigint() { echo "> Caught SIGINT"; rm ${FIFO_NAME}; }

mkfifo ${FIFO_NAME}
nc -kl ${LISTEN_PORT} < ${FIFO_NAME} | nc ${BACKEND_HOST} ${BACKEND_PORT} > ${FIFO_NAME}
