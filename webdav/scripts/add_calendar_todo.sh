source env_base.sh

collection=$collection_work
uuid=$test_todo_uuid

curl -v -X PUT -u "$user:$pass" \
  -H "Content-Type: text/calendar; charset=utf-8" \
  -H "If-None-Match: *" \
  -d "BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Example//Example//EN
BEGIN:VTIMEZONE
TZID:Asia/Shanghai
BEGIN:STANDARD
DTSTART:19700101T000000
TZOFFSETFROM:+0800
TZOFFSETTO:+0800
TZNAME:CST
END:STANDARD
END:VTIMEZONE
BEGIN:VTODO
UID:$uuid@matrix.works
DTSTAMP:20260608T000000Z
DTSTART;TZID=Asia/Shanghai:20260610T110000
DUE;TZID=Asia/Shanghai:20260615T180000
SUMMARY:完成季度报告
DESCRIPTION:包含数据分析和图表
PRIORITY:1
STATUS:NEEDS-ACTION
PERCENT-COMPLETE:0
END:VTODO
END:VCALENDAR" \
  https://$host/$user/$collection/$uuid.ics
