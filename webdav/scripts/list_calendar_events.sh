source env_base.sh

collection=$collection_work

curl -s -u $user:$pass \
  -X REPORT \
  -H "Depth: 1" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
<c:calendar-query xmlns:d="DAV:" xmlns:c="urn:ietf:params:xml:ns:caldav">
<d:prop>
<d:getetag/>
<c:calendar-data/>
</d:prop>
<c:filter>
<c:comp-filter name="VCALENDAR">
<c:comp-filter name="VEVENT"/>
</c:comp-filter>
</c:filter>
</c:calendar-query>' \
  https://$host/$user/$collection/ | xq
