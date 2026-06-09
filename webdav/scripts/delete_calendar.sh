source env_base.sh

work=$collection_work

curl -v -u $user:$pass \
  -X DELETE \
  https://$host/$user/$work/
