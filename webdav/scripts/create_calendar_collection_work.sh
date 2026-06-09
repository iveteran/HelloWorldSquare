source env_base.sh

collection=$collection_work

curl -v -u $user:$pass \
    -X MKCOL \
    -H "Content-Type: application/xml" \
    -d '<?xml version="1.0"?>
<d:mkcol xmlns:d="DAV:" xmlns:cal="urn:ietf:params:xml:ns:caldav">
<d:set>
<d:prop>
<d:resourcetype>
<d:collection/>
<cal:calendar/>
</d:resourcetype>
<d:displayname>工作日历Demo</d:displayname>
<cal:supported-calendar-component-set>
<cal:comp name="VEVENT"/>
<cal:comp name="VTODO"/>
</cal:supported-calendar-component-set>
</d:prop>
</d:set>
</d:mkcol>' \
    https://$host/$user/$collection/
