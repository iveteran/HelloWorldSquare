# Setup Postfixadmin

## Install
sudo apt install postfixadmin

## Configuration directories/files
/etc/postfixadmin
/etc/postfixadmin/apache.conf

## Symbol links
/etc/apache2/conf-available/postfixadmin.conf -> /etc/postfixadmin/apache.conf

/usr/share/postfixadmin/config.inc.php -> /etc/postfixadmin/config.inc.php
/usr/share/postfixadmin/config.local.php -> /etc/postfixadmin/config.local.php

## Program directory
/usr/share/postfixadmin/


## Database file
/var/lib/postfixadmin/postfix.sqlite
sudo chown -R www-data:www-data /var/lib/postfixadmin
sudo chown 640 /var/lib/postfixadmin/postfix.sqlite
- Add postfix and dovecot to group www-data
  sudo usermod -aG www-data postfix
  sudo usermod -aG www-data dovecot

## Access via ssh tunnel
ssh -Nf -L 8080:127.0.0.1:80 servername

curl http://localhost:8080/postfixadmin

NOTE: Make sure /etc/apache/site-available/000-default.conf has below:
</VirtualHost *:80>
    # ...
    RewriteCond %{HTTP_HOST} !^localhost$
    RewriteCond %{REMOTE_ADDR} !^127\.0\.0\.1$
    RewriteCond %{REMOTE_ADDR} !^::1$
    # ...
</VirtualHost>
