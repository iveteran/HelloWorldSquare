source env_base.sh

curl -v -X OPTIONS https://$host/

# 响应头包含：
# Allow: GET, HEAD, OPTIONS, PROPFIND, PUT, DELETE, MKCOL, MKCALENDAR, REPORT, PROPPATCH
# DAV: 1, 2, 3, calendar-access, addressbook
#
# DAV: 响应头表示支持级别：
# 值    含义
# 1     基础 WebDAV
# 2     支持 LOCK
# 3     支持条件更新
# calendar-access   支持 CalDAV
# addressbook       支持 CardDAV
