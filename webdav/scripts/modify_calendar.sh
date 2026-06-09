source env_base.sh

collection=$collection_work

curl -v -u $user:$pass \
  -X PROPPATCH \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
  <d:propertyupdate xmlns:d="DAV:">
  <d:set>
  <d:prop>
  <d:displayname>工作日历Demo（已更新）</d:displayname>
  </d:prop>
  </d:set>
  </d:propertyupdate>' \
  https://$host/$user/$collection/
