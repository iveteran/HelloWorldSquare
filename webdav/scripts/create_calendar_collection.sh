source env_base.sh

calendar="my-calendar"

curl -v -u $user:$pass \
  -X MKCOL \
  -H "Content-Type: application/xml" \
  -d "<?xml version='1.0'?>
  <d:mkcol xmlns:d='DAV:' xmlns:cal='urn:ietf:params:xml:ns:caldav'>
    <d:set>
      <d:prop>
        <d:resourcetype>
          <d:collection/>
            <cal:calendar/>
          </d:resourcetype>
        <d:displayname>$calendar</d:displayname>
      </d:prop>
    </d:set>
  </d:mkcol>" \
  https://$host/$user/$calendar/
