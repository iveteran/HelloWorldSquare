source env_base.sh

curl -s -u $user:$pass \
  -X PROPFIND \
  -H "Depth: 1" \
  -H "Content-Type: application/xml" \
  https://$host/$user
