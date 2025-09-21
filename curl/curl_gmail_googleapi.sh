ACCESS_TOKEN="your-access-token"

## Use oauth2 token access Gmail with API
#curl -H "Authorization: Bearer $ACCESS_TOKEN" \
#     "https://gmail.googleapis.com/gmail/v1/users/me/labels/INBOX"

curl "https://openidconnect.googleapis.com/v1/userinfo" \
    -H "Authorization: Bearer $ACCESS_TOKEN"
# userinfo response:
#{
#    sub: 101617646158275192438,
#    name: Iveteran Yu,
#    given_name: Iveteran,
#    family_name: Yu,
#    picture: https://lh3.googleusercontent.com/a/ACg8ocJ_LOEdvXww0DLfV2KSIhllSPxcUBK-IahZTcVgvDmCEvOU7D3K=s96-c,
#    email: iveteran.yuu@gmail.com,
#    email_verified: true
#}
