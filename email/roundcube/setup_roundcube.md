# Setup Roundcube (Debian)

## Install
sudo apt install roundcube roundcube-sqlite3

## Locations
/usr/share/roundcube
/var/lib/roundcube
/etc/roundcube

## Configuration files
/etc/roundcube/debian-db.php
/etc/roundcube/config.inc.php
/etc/roundcube/apache.conf

## Symbol links
/etc/apache2/conf-available/roundcube.conf -> /etc/roundcube/apache.conf

## Database files
/var/lib/roundcube/roundcube.sqlite
chown www-data:www-data /var/lib/roundcube
chown www-data:www-data /var/lib/roundcube/roundcube.sqlite
