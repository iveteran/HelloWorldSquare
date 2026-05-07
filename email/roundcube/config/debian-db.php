<?php
##
## database access settings in php format
## automatically generated from /etc/dbconfig-common/roundcube.conf
## by /usr/sbin/dbconfig-generate-include
##
## by default this file is managed via ucf, so you shouldn't have to
## worry about manual changes being silently discarded.  *however*,
## you'll probably also want to edit the configuration file mentioned
## above too.
##
#$dbtype='mysql';
$dbtype='sqlite';
#$dbuser='roundcube';
#$dbpass='YourPassword';
#$dbname='roundcube';
#$dbserver='localhost';
#$dbport='3306';
$basepath='/var/lib/roundcube';
$dbname='roundcube.sqlite';
