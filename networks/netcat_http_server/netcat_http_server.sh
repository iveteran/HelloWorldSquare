echo "Running ..."
while true; do 
  #echo -e "HTTP/1.1 200 OK\n\n $(date)" | nc -l -p 8088  # respond plain text
  #echo -e "HTTP/1.1 200 OK\n\n {\"server_time\": \"$(date)\"}" | nc -l -p 8088  # respond json

  RSP="HTTP/1.1 200 OK\n\n {\"server_time\": \"$(date)\"}"
  echo -e $RSP | nc -l -p 8088
  printf "\n\n"
  echo $RSP
done
