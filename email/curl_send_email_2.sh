#!/bin/sh

#HOST="smtps://goe.works/"
#USERNAME="abc@matrix.works"
#TO_USER="yusen@goe.works"

HOST="smtps://goe.works/"
USERNAME="abc@y-things.com"
TO_USER="yusen@goe.works"

#HOST="smtps://matrix.works/"
#USERNAME="abc@y-things.com"
#TO_USER="yu@works.works"

echo "Sending to $TO_USER ..."
curl -v --insecure $HOST \
  --mail-from $USERNAME \
  --mail-rcpt $TO_USER \
  --upload-file email_2.txt
