#!/bin/sh

HOST="smtps://goe.works/"
USERNAME="abc@yusen.me"
TO_USER="yusen@goe.works"

echo "Sending to $TO_USER ..."
curl -v --insecure $HOST \
  --mail-from $USERNAME \
  --mail-rcpt $TO_USER \
  --upload-file email.txt
