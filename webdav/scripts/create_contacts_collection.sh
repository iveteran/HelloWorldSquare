source env_base.sh

collection=$collection_contacts

curl -v -u $user:$pass \
  -X MKCOL \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
  <d:mkcol xmlns:d="DAV:" xmlns:card="urn:ietf:params:xml:ns:carddav">
    <d:set>
      <d:prop>
        <d:resourcetype>
          <d:collection/>
            <card:addressbook/>
          </d:resourcetype>
        <d:displayname>contacts</d:displayname>
      </d:prop>
    </d:set>
  </d:mkcol>' \
  https://$host/$user/$collection/
