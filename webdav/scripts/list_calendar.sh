source env_base.sh

collection=$collection_work

curl -s -u $user:$pass \
  -X PROPFIND \
  -H "Depth: 1" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
  <d:propfind xmlns:d="DAV:" xmlns:cal="urn:ietf:params:xml:ns:caldav">
  <d:prop>
  <d:displayname/>
  <d:resourcetype/>
  <cal:supported-calendar-component-set/>
  </d:prop>
  </d:propfind>' \
  https://$host/$user/$collection
