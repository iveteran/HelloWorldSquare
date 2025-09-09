#!/bin/bash
#
# 使用 IMAP XOAUTH2 方式访问邮箱（以 Gmail 为例）
#

EMAIL="iveteran.yuu@gmail.com"
#ACCESS_TOKEN="ya29.a0ARrdaM8jxxxx..."   # 你的 OAuth2 Access Token
ACCESS_TOKEN="ya29.a0AS3H6NxsU2n4aFiXcjBUy354QF76JYEA24vbrxXe12nUrooIKXlJCCvemUcWTn6uDeW0MuoIpih4XDX-WSSLoBwnIh9tPvZneSWDnynnzWdG0EXGeSXxGnxO-aVW2WUWlR_PV09wOnDJv1EbPXRPStn9zV8fNhhV9AvNgl8u8aIWrHtV4TnDyB9bmMkKMB-sY74h7_IaCgYKAfUSARQSFQHGX2MiPDVtOeRQ0NyywLNvwILlWQ0206"

IMAP_SERVER="imap.gmail.com"
IMAP_PORT=993

# 构造 XOAUTH2 字符串
AUTH_STRING="user=${EMAIL}\x01auth=Bearer ${ACCESS_TOKEN}\x01\x01"
# Base64 编码
AUTH_STRING_B64=$(printf "${AUTH_STRING}" | base64 | tr -d '\n')

echo "=== 尝试使用 XOAUTH2 登录 IMAP ==="

# 使用 curl 执行 IMAP 命令
# 列出所有folders
curl -v -s --url "imaps://${IMAP_SERVER}:${IMAP_PORT}" \
     --user "$EMAIL" \
     --oauth2-bearer "$ACCESS_TOKEN"

## 列出Inbox前5封邮件
#curl -v -s --url "imaps://${IMAP_SERVER}:${IMAP_PORT}/INBOX" \
#     --user "$EMAIL" \
#     --oauth2-bearer "$ACCESS_TOKEN" \
#     --request "FETCH 1:5 (BODY[HEADER.FIELDS (SUBJECT)])"
#
## 创建folder
#curl -v -s --url "imaps://${IMAP_SERVER}:${IMAP_PORT}" \
#     --user "$EMAIL" \
#     --oauth2-bearer "$ACCESS_TOKEN" \
#     --request "CREATE IncontrolChat"
