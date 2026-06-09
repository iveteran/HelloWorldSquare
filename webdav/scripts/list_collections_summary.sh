source env_base.sh

curl -s -u $user:$pass \
  -X PROPFIND \
  -H "Depth: 1" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<d:propfind xmlns:d="DAV:"
xmlns:cal="urn:ietf:params:xml:ns:caldav"
xmlns:card="urn:ietf:params:xml:ns:carddav"
xmlns:cs="http://calendarserver.org/ns/">
<d:prop>
<d:getcontenttype/>
<d:getlastmodified/>
<d:displayname/>
<cal:supported-calendar-component-set/>
<cs:getctag/>
</d:prop>
</d:propfind>' \
  https://$host/$user
