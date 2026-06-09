source env_base.sh

collection=$collection_work

curl -s -u $user:$pass \
  -X PROPFIND \
  -H "Depth: 1" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
<d:propfind xmlns:d="DAV:">
<d:prop>
<d:getetag/>
<d:getcontenttype/>
</d:prop>
</d:propfind>' \
  https://$host/$user/$collection/
