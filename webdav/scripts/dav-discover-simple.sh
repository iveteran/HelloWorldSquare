source env_base.sh

echo "获取当前用户的principal:"
curl -s -L -u "$user:$pass" \
  -X PROPFIND \
  -H "Depth: 0" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
<d:propfind xmlns:d="DAV:">
<d:prop>
<d:current-user-principal/>
</d:prop>
</d:propfind>' \
  https://$host/.well-known/carddav | xq -n -x //multistatus/response/propstat/prop/current-user-principal

# Response contains:
# <?xml version='1.0' encoding='utf-8'?>
# <multistatus xmlns="DAV:">
#   <response>
#     <href>/</href>
#     <propstat>
#       <prop>
#         <principal-collection-set>
#           <href>/</href>
#         </principal-collection-set>
#         <current-user-principal>
#           <href>/test001%40matrix.works/</href>
#         </current-user-principal>
#         ...
#       <prop>
#     <propstat>
#   <response>
# <multistatus xmlns="DAV:">

echo "获取collection home set:"
curl -s -L -u "$user:$pass" \
  -X PROPFIND \
  -H "Depth: 0" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0"?>
<d:propfind xmlns:d="DAV:"
  xmlns:cal="urn:ietf:params:xml:ns:caldav"
  xmlns:card="urn:ietf:params:xml:ns:carddav">
<d:prop>
<cal:calendar-home-set/>
<card:addressbook-home-set/>
</d:prop>
</d:propfind>' \
  https://$host/$user/ | xq -n -x //multistatus/response/propstat/prop

# Response:
#<?xml version='1.0' encoding='utf-8'?>
#  <multistatus xmlns="DAV:" xmlns:C="urn:ietf:params:xml:ns:caldav" xmlns:CR="urn:ietf:params:xml:ns:carddav">
#  <response>
#    <href>/test001%40matrix.works/</href>
#    <propstat>
#      <prop>
#        <C:calendar-home-set>
#          <href>/test001%40matrix.works/</href>
#        </C:calendar-home-set>
#        <CR:addressbook-home-set>
#          <href>/test001%40matrix.works/</href>
#        </CR:addressbook-home-set>
#      </prop>
#      <status>HTTP/1.1 200 OK</status>
#    </propstat>
#  </response>
#</multistatus>

echo "获取collection列表(只显示url和名称):"
curl -s -L -u "$user:$pass" \
  -X PROPFIND \
  -H "Depth: 1" \
  -H "Content-Type: application/xml" \
  -d '<?xml version="1.0" encoding="utf-8"?>
<d:propfind xmlns:d="DAV:"
  xmlns:cal="urn:ietf:params:xml:ns:caldav"
  xmlns:card="urn:ietf:params:xml:ns:carddav"
  xmlns:cs="http://calendarserver.org/ns/">
<d:prop>
<d:displayname/>
<d:resourcetype/>
<cal:supported-calendar-component-set/>
<cs:getctag/>
</d:prop>
</d:propfind>' \
  https://$host/$user/ | \
  tee >(xq -n -x //multistatus/response/propstat/prop/displayname) \
    >(xq -n -x //multistatus/response/href) \
    >/dev/null
  #https://$host/$user/ | xq

# XXX: 上述指令导致终端回显失效，如下命令重置回显
stty sane
