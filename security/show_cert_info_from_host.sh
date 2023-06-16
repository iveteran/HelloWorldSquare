#echo matrixworks.cn:443
#openssl s_client -connect matrixworks.cn 2>/dev/null | openssl x509 -noout -dates

# imaps
echo -- mail.iveteran.me/imaps
openssl s_client -connect mail.iveteran.me:993 2>/dev/null | openssl x509 -noout -dates

# pop3s
#echo -- mail.iveteran.me/pop3s
#openssl s_client -connect mail.iveteran.me:995 2>/dev/null | openssl x509 -noout -dates

# smtps
#echo -- mail.iveteran.me/smtps
#openssl s_client -connect mail.iveteran.me:465 2>/dev/null | openssl x509 -noout -dates
