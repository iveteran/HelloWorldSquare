# Ref: https://easydmarc.com/blog/how-to-configure-dkim-opendkim-with-postfix/
#      https://www.linuxbabe.com/redhat/set-up-spf-dkim-postfix-centos
#
# 1. Install & run OpenDKIM
# Debian 12
sudo apt install opendkim
# CentOS Stream 9:
# NEED enable CRB, otherwise will appear:
# Error:
#  Problem: conflicting requests
#   - nothing provides libmilter.so.1.0()(64bit) needed by opendkim-2.11.0-0.28.el9.x86_64
#   - nothing provides libmemcached.so.11()(64bit) needed by opendkim-2.11.0-0.28.el9.x86_64
dnf config-manager --set-enabled crb # CodeReady Linux Builder (CRB) repository
dnf install opendkim

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
#Keyfile /etc/opendkim/keys/default.private
KeyTable /etc/opendkim/KeyTable
SigningTable refile:/etc/opendkim/SigningTable
ExternalIgnoreList refile:/etc/opendkim/TrustedHosts
InternalHosts refile:/etc/opendkim/TrustedHosts

# add below two options
#Domain yourdomain.com
#Domain yourdomain2.com
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
#  dig txt yourselector._domainkey.yourdomain.com

# 5: Connect Postfix to OpenDKIM
# Edit /etc/postfix/main.cf, add below options:
smtpd_milters = inet:127.0.0.1:8891
#smtpd_milters = local:/run/opendkim/opendkim.sock # MUST make sure Postfix has permission to access to this sock file, sudo usermod -aG opendkim postfix
non_smtpd_milters = $smtpd_milters
milter_default_action = accept

# Restart postfix
sudo systemctl restart postfix

# Query dkim dns record
dig txt default._domainkey.yourdomain.com
