source env_base.sh

collection=$collection_contacts
uuid=$test_contact_uuid

# NOTE: vcard的内容必须每行顶格写

curl -v -u $user:$pass \
  -X PUT \
  -H "Content-Type: text/vcard; charset=utf-8" \
  -d "
BEGIN:VCARD
VERSION:3.0
UID:$uuid
FN:俞生
N:俞;生;;;
EMAIL;TYPE=WORK:yusen@matrix.works
TEL;TYPE=MOBILE:+86 123 0000 0000
ORG:矩阵工场
END:VCARD" \
  https://$host/$user/$collection/$uuid.vcf
