#!/bin/bash
#
# 使用 Graph API 方式访问Outlook邮箱
#

EMAIL="iveteran.yuu@outlook.com"
#ACCESS_TOKEN="ya29.a0ARrdaM8jxxxx..."   # 你的 OAuth2 Access Token
ACCESS_TOKEN="EwBIBMl6BAAUBKgm8k1UswUNwklmy2v7U/S+1fEAAQRhsmFOFOTvyj3WgnWFLQyfzQmyvNmATRKNMhuEUi5SpvgeQkDWiSoYyjyduCva/3fQJ7mANAJ9Ti3XGkh34GtRe2YAYuxrADz+fJ/xTf+0Vu9X15UfiPHuBfuOc0F7j5gL7W9tMoZspZukN52ua1hiyh/4Je5Vt+YwQK9RZjRqn7CfUCVuhMcFrr1iZzWjqREEPMwbRZNPmiTpeFDhxILxlh5f1cp8mf9gHynwmtzse/1RPIZJnBk3ZrvU+sTtm4RLl8tiImpRxGHfkQkH8wlLY7G8vSn4OEN0WjBwzPfPGKnnEjF4oK9m6iut2E5MnS4o2TYabTsGIzmUFvDucyUQZgAAEK5f7IlB3y2qa5ksAc6PdXUQAw5itqhs3Wvaa4Nm1tB2XaA0PVtrdEvHPdXXtDLPcAfM4Y1AOm311RxxVojazwkLQ/40sWiMXvmGOlFX0XZpVce6lvSyC3TvHfO2ny3KJvMb0uZrBhKkko4K2UGpRic0v9avSOZ0D5miq334etp31MHDF2zRezv1eS9cxDiAbgl74V6o8pCJK4LcNIKna6X7bPX3mcAFefoZbUB+ECzuTnThXEGna3yvv+48kZjj15nZWkmC/hLZ2kGwqfQmoT8+ao6zIO9N9I2NDOgKt9aR92E5rGQvus4Xh6S4PnawO6u0UtLTufDdClZ5QXEYAPYbjSS8sufYDfkWXC392oC18qzrLt53xlhEBMI5kv1QB4bBMzg9QB7DMv2lWBTKqDjYpw64t4LRtnwciaHWijr2a3wTKCCQ8izXC756o4RPx6aiwhPzDBRT0rcRo4e54lqyRb1iVupHLMvam9MZBU3uptTGxL27/ycY/9If2sCE0JLp+94G6CdKQ4+YM2xit80cXMEWBZ6wMpuUP8cQ11n02JHD03VltLQdm6msTXKyPhkJwGXnGE3w3yQPq1P02NsXbad1zFwhRXsyWRm6APluzgBcRllUkzFKpbg+if2EO9jvhB9LA0CMbQhwxIQbxiwHFjK29jK5q3sg5LdmIYbjJ+4klvgtJZcepenrEmkqbU7nljxEOoLyrigLCM4ESubHUb0VbnFJd6uS3EoSB06JQqTRWDR2Z4VLhNrhxKzGbnv3x5MlXNsS77sN4OAkeO1qF7UlW6B/pucA22K0dKXmBjZTRd5n0GrwZNMa4aZVIZOY8G16P/bIPUERIY1YDYffyr/Yg4HgdEMBK7uVvwhyjAPTdyzpQUuNUexUIWOswPzCmg30EQkGmV4dcL/l4/k0Fezocl+klsyov9VN+BiUSgsA8Ub6FlQbPMfu7Dj2qoD8+4e6UkM3G6+q27ZVzTjMiosMZofdfLgXYY8wgfHdzBCZxSY2v10nAoz6FRbITWsX4eqscBRPuXaMM09hqxWloR10n6ubAA2Kf0ChtWZ//qNNAw=="

# 获取用户信息
url -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Accept: application/json" \
     "https://graph.microsoft.com/oidc/userinfo" | jq

## 列出所有folders
#curl -H "Authorization: Bearer $ACCESS_TOKEN" \
#     -H "Accept: application/json" \
#     "https://graph.microsoft.com/v1.0/me/mailFolders" | jq

## 列出Inbox前5封邮件
#curl -H "Authorization: Bearer $ACCESS_TOKEN" \
#     -H "Accept: application/json" \
#     "https://graph.microsoft.com/v1.0/me/messages?\$select=subject,from&\$top=5" | jq

## 创建folder
#curl -H "Authorization: Bearer $ACCESS_TOKEN" \
#     -H "Content-Type: application/json" \
#     -d '{ "displayName": "IncontrolChat" }' \
#     "https://graph.microsoft.com/v1.0/me/mailFolders" | jq

#{
#  "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users('iveteran.yuu%40outlook.com')/mailFo
#lders/$entity",
#  "id": "AQMkADAwATNiZmYAZC1kZAA5NC00ZDc2LTAwAi0wMAoALgAAA69PPvAVKuBEmF8_03JtlxsBAN5-7RPAGjFMsHrqBYiFlHEAC
#ISgRMEAAAA=",
#  "displayName": "IncontrolChat",
#  "parentFolderId": "AQMkADAwATNiZmYAZC1kZAA5NC00ZDc2LTAwAi0wMAoALgAAA69PPvAVKuBEmF8_03JtlxsBAN5-7RPAGjFMs
#HrqBYiFlHEAAAIBCAAAAA==",
#  "childFolderCount": 0,
#  "unreadItemCount": 0,
#  "totalItemCount": 0,
#  "sizeInBytes": 0,
#  "isHidden": false
#}

## 创建子folder
#parent_folder_id="AQMkADAwATNiZmYAZC1kZAA5NC00ZDc2LTAwAi0wMAoALgAAA69PPvAVKuBEmF8_03JtlxsBAN5-7RPAGjFMsHrqBYiFlHEACISgRMEAAAA="
#curl -H "Authorization: Bearer $ACCESS_TOKEN" \
#     -H "Content-Type: application/json" \
#     -d '{ "displayName": "Contacts" }' \
#     "https://graph.microsoft.com/v1.0/me/mailFolders/$parent_folder_id/childFolders" | jq

# 发送邮件
curl -X POST https://graph.microsoft.com/v1.0/me/sendMail \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
        "message": {
          "subject": "测试邮件",
          "body": {
            "contentType": "Text",
            "content": "你好，这是通过 Microsoft Graph API 发送的邮件。"
          },
          "toRecipients": [
            {
              "emailAddress": {
                "address": "test001@matrix.works"
              }
            }
          ]
        },
        "saveToSentItems": "true"
      }'
