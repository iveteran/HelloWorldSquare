source env_base.sh

collection=$collection_contacts
uuid=$test_contact_uuid

curl -v -u $user:$pass \
  https://$host/$user/$collection/$uuid.vcf
