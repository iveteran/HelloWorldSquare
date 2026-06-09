source env_base.sh

collection=$collection_work

curl -v -u $user:$pass \
  -X PROPFIND \
  -H "Content-Type: application/xml" \
  -H "Depth: 1" \
  https://$host/$user/$collection/
