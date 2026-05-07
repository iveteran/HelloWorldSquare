<?php

/*
 +-----------------------------------------------------------------------+
 | Local configuration for the Roundcube Webmail installation.           |
 |                                                                       |
 | This is a sample configuration file only containing the minimum       |
 | setup required for a functional installation. Copy more options       |
 | from defaults.inc.php to this file to override the defaults.          |
 |                                                                       |
 | This file is part of the Roundcube Webmail client                     |
 | Copyright (C) The Roundcube Dev Team                                  |
 |                                                                       |
 | Licensed under the GNU General Public License version 3 or            |
 | any later version with exceptions for skins & plugins.                |
 | See the README file for a full license statement.                     |
 +-----------------------------------------------------------------------+
*/

$config = [];

// Do not set db_dsnw here, use dpkg-reconfigure roundcube-core to configure database!
include("/etc/roundcube/debian-db-roundcube.php");

// IMAP host chosen to perform the log-in.
// See defaults.inc.php for the option description.
$config['imap_host'] = ["localhost:143"];

// SMTP server host (for sending mails).
// See defaults.inc.php for the option description.
//$config['smtp_host'] = 'localhost:587';  // method 1: submissions, starttls, authentication failure
$config['smtp_host'] = 'localhost:25';     // method 2: smtp, plain, success
//$config['smtp_server'] = 'ssl://mail.goe.works';   // method 3: submission, tls, success
//$config['smtp_port'] = 465;

// SMTP username (if required) if you use %u as the username Roundcube
// will use the current username for login
$config['smtp_user'] = '%u';

// SMTP password (if required) if you use %p as the password Roundcube
// will use the current user's password for login
$config['smtp_pass'] = '%p';

// provide an URL where a user can get support for this Roundcube installation
// PLEASE DO NOT LINK TO THE ROUNDCUBE.NET WEBSITE HERE!
$config['support_url'] = '';

// Name your service. This is displayed on the login screen and in the window title
$config['product_name'] = 'Matrixworks Webmail';

// This key is used to encrypt the users imap password which is stored
// in the session record. For the default cipher method it must be
// exactly 24 characters long.
// YOUR KEY MUST BE DIFFERENT THAN THE SAMPLE VALUE FOR SECURITY REASONS
$config['des_key'] = 'Secret Key';

// List of active plugins (in plugins/ directory)
// Debian: install roundcube-plugins first to have any
$config['plugins'] = [
    //"filesystem_attachments",
    "jqueryui",
    "attachment_reminder",
    "archive",
    "debug_logger",
    "autologout",
    "autologon",
    "example_addressbook",
    "identity_select",
    "identicon",
    "hide_blockquote",
    "new_user_dialog",
    "show_additional_headers",
    "subscriptions_option",
    "virtuser_query",
    "virtuser_file",
    "vcard_attachments",
    "userinfo",
    "zipdownload",
    "squirrelmail_usercopy",
    "redundant_attachments",
    "reconnect",
    "password",
    "new_user_identity",
    "newmail_notifier",
    "markasjunk",
    "managesieve",
    "krb_authentication",
    "http_authentication",
    "help",
    "enigma",
    "emoticons",
    //"database_attachments",
    "additional_message_headers",
    "acl",
    "contextmenu",
    //"listcommands",
    //"html5_notifier",
    "fail2ban",
    //"thunderbird_labels",
    //"sauserprefs",
    //"message_highlight",
    //"keyboard_shortcuts",
    //"dovecot_impersonate",
    "compose_addressbook",
    //"authres_status",
];

// skin name: folder from skins/
$config['skin'] = 'elastic';

// Disable spellchecking
// Debian: spellchecking needs additional packages to be installed, or calling external APIs
//         see defaults.inc.php for additional informations
$config['enable_spellcheck'] = false;

$config['enable_installer'] = false;
