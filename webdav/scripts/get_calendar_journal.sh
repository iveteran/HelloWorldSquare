source env_base.sh

collection=$collection_work
uuid=$test_journal_uuid

# 查看单个资源
curl -u $user:$pass \
  -X GET \
  https://$host/$user/$collection/$uuid.ics

echo

# 列出日历下所有资源（PROPFIND）
curl -u $user:$pass \
  -X PROPFIND \
  -H "Depth: 1" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
<d:propfind xmlns:d="DAV:">
<d:prop>
<d:getetag/>
</d:prop>
</d:propfind>' \
  https://$host/$user/$collection/$uuid.ics
