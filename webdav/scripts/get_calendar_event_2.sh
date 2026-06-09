source env_base.sh

collection="my-calendar"
uuid=$test_event_uuid_2

curl -s -u $user:$pass \
  https://$host/$user/$collection/$uuid.ics
