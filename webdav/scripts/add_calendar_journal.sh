source env_base.sh

collection=$collection_work
uuid=$test_journal_uuid

curl -v -X PUT \
  -u "$user:$pass" \
  -H "Content-Type: text/calendar; charset=utf-8" \
  -H "If-None-Match: *" \
  -d "BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Example//Example//EN
BEGIN:VJOURNAL
UID:$uuid@matrix.works
DTSTAMP:20260608T000000Z
DTSTART;VALUE=DATE:20260608
SUMMARY:今日工作日志
DESCRIPTION:完成了用户认证模块的开发\n修复了3个已知bug\n明日计划：开始写单元测试
STATUS:FINAL
END:VJOURNAL
END:VCALENDAR" \
  https://$host/$user/$collection/$uuid.ics \
