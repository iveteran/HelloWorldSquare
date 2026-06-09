source env_base.sh

collection=$collection_work
uuid=$test_event_uuid

curl -s -u $user:$pass \
  https://$host/$user/$collection/$uuid.ics
