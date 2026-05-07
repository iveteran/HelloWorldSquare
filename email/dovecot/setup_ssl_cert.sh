domain_name="matrix.works"
sudo su
cd /etc/dovecot/private
rm dovecot.pem dovecot.key
ln -s /home/acme/$domain_name.cert.pem dovecot.pem
ln -s /home/acme/$domain_name.key.pem dovecot.key
