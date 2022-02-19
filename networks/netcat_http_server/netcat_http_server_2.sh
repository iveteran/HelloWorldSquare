echo "Running ..."
while true; do cat index.html | nc -l 8088; done
