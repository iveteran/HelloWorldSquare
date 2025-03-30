HOST=127.0.0.1
PORT=80

if [ $# == 0 ]; then
    echo "Usage: $0 <HOST> [PORT]"
    exit 1
fi
if [ $# == 1 ]; then
    HOST=$1
fi
if [ $# == 2 ]; then
    PORT=$2
fi

printf "GET / HTTP/1.1\r\nHost:$HOST\r\nUser-Agent:nc\r\nAccept:*/*\r\n\r\n" | nc $HOST $PORT
