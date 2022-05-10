#!/bin/sh
# Dump the subject of all messages in the folder.
# Ref: http://server1.sharewiz.net/doku.php?id=curl:perform_imap_queries_using_curl

USERNAME="yu@iveteran.me"

read -s -p "Type password of user $USERNAME: "
echo ""
PASSWORD=${REPLY}
unset REPLY

id=1

while true ; do
  echo "Message ${id}"
  curl --insecure \
    --url "imaps://mail.iveteran.me/INBOX;UID=${id};SECTION=HEADER.FIELDS%20(SUBJECT%20FROM%20TO%20DATE)" \
    --user "$USERNAME:$PASSWORD" || exit
  id=`expr $id + 1`
done
