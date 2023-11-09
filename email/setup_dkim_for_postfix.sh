# Ref: https://easydmarc.com/blog/how-to-configure-dkim-opendkim-with-postfix/
#
# 1. Install & run OpenDKIM
sudo apt install opendkim
sudo systemctl start opendkim
sudo systemctl enable opendkim
sudo systemctl status opendkim

# 2. Generate opendkim key-pairs, use your e-mail domain replace of "yourdomain.com"
sudo mkdir /etc/opendkim/keys/yourdomain.com
sudo opendkim-genkey -b 1024 -d yourdomain.com -D /etc/opendkim/keys/yourdomain.com -s default -v
sudo chown opendkim:opendkim /etc/opendkim/keys -R

# 3. Edit opendkim main configure file
# 1) /etc/opendkim.conf, uncomment/modify below options
Mode sv
Keyfile
KeyTable
SigningTable
ExternalIgnoreList
InternalHosts

# add below two options
Domain yourdomain.com
RequireSafeKeys False

# 2) Edit /etc/opendkim/SigningTable, add:
# In most cases, use "default" replace of "yourselector"
*@yourdomain.com yourselector._domainkey.yourdomain.com

# 3) Edit /etc/opendkim/KeyTable, add:
youselector._domainkey.yourdomain.com yourdomain.com:selector:/etc/opendkim/keys/yourdomain.com/default.private

# 4) Edit /etc/opendkim/TrustedHosts, add:
*.yourdomain.com

# 4. Publish the created public key in your DNS (Godaddy, Cloudflare, etc.)
# Copy the public key: /etc/opendkim/keys/yourdomain.com/default.txt
# Important Notes:
# Name/Target: yourselector._domainkey
# Content: Value you’ve copied in the previous stage. Make sure to remove any spaces or double-quotes.
# Verify result via dig:
#  dig yourselector._domainkey.yourdomain.com

# 5: Connect Postfix to OpenDKIM
# Edit /etc/postfix/main.cf, add below options:
smtpd_milters = inet:127.0.0.1:8891
non_smtpd_milters = $smtpd_milters
milter_default_action = accept

# Restart postfix
sudo systemctl restart postfix
