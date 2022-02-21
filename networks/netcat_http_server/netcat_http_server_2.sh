LISTEN_PORT=8088
echo "Listens on ${LISTEN_PORT} ..."
while true; do cat index.html | nc -l ${LISTEN_PORT}; done
