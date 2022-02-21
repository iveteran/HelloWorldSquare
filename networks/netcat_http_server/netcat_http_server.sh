PORT=8080
echo "Listen on ${PORT} ..."
while true; do 
  #echo -e "HTTP/1.1 200 OK\n\n $(date)" | nc -l -p ${PORT}  # respond plain text
  #echo -e "HTTP/1.1 200 OK\n\n {\"server_time\": \"$(date)\"}" | nc -l -p ${PORT}  # respond json

  RSP="HTTP/1.1 200 OK\n\n {\"server_time\": \"$(date)\"}\n\n"
  echo -e $RSP | nc -l -p ${PORT}
  printf "\n\n"
  echo $RSP
done
