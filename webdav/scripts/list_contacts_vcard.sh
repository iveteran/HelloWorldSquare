source env_base.sh

collection=$collection_contacts

curl -s -u $user:$pass \
  -X REPORT \
  -H "Depth: 1" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
  <card:addressbook-query xmlns:card="urn:ietf:params:xml:ns:carddav" xmlns:d="DAV:">
  <d:prop>
  <d:getetag/>
  <card:address-data/>
  </d:prop>
  </card:addressbook-query>' \
  https://$host/$user/$collection/
