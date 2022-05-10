#!/bin/sh

HOST="smtps://mail.iveteran.me/"
USERNAME="yu@iveteran.me"
TO_USER_1="iveteran.yuu@outlook.com"
TO_USER_2="test001@matrix.works"

read -s -p "Type password of user $USERNAME: "
echo ""
PASSWORD=${REPLY}
unset REPLY

echo "Sending to $TO_USER_1 ..."
curl --insecure $HOST \
  -u "$USERNAME:$PASSWORD" \
  --mail-from $USERNAME \
  --mail-rcpt $TO_USER_1 \
  --upload-file email.txt

echo "Sending to $TO_USER_2 ..."
curl --insecure $HOST \
  -u "$USERNAME:$PASSWORD" \
  --mail-from $USERNAME \
  --mail-rcpt $TO_USER_2 \
  --upload-file email2.txt
