remote_host="mail.matrix.works"
show_cert="openssl x509 -inform pem -noout -subject -issuer -dates -ext subjectAltName"

echo "** $remote_host:443 https **"
echo | openssl s_client -showcerts -servername $remote_host -connect $remote_host:443 2>/dev/null | eval $show_cert

echo
echo "** $remote_host:465 smtps **"
echo | openssl s_client -showcerts -servername $remote_host -connect $remote_host:465 2>/dev/null | eval $show_cert

echo
echo "** $remote_host:993 imaps **"
echo | openssl s_client -showcerts -servername $remote_host -connect $remote_host:993 2>/dev/null | eval $show_cert

echo
echo "** $remote_host:995 pop3s **"
echo | openssl s_client -showcerts -servername $remote_host -connect $remote_host:995 2>/dev/null | eval $show_cert
