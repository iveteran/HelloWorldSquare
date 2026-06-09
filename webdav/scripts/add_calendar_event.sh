source env_base.sh

collection=$collection_calendar

uuid=$test_event_uuid

curl -v -u $user:$pass \
  -X PUT \
  -H "Content-Type: text/calendar; charset=utf-8" \
  -d "BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Test//Test//EN
BEGIN:VEVENT
UID:${uuid}@${domain}
DTSTAMP:$(date -u +%Y%m%dT%H%M%SZ)
DTSTART:20260610T090000Z
DTEND:20260610T100000Z
SUMMARY:测试会议
DESCRIPTION:这是一个测试事件
LOCATION:会议室A
END:VEVENT
END:VCALENDAR" \
  https://$host/$user/$collection/${uuid}.ics
