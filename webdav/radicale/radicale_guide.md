# Integrate CalDAV and CardDAV to email system

## Install
sudo apt install radicale
sudo chown -R radicale:radicale /var/lib/radicale

## Configurate
Location: /etc/radicale

type: imap
imap_host: localhost:143
imap_security: none
lc_username: True

predefined_collections = {
    "def-calendar": {
        "D:displayname": "Personal Calendar",
        "C:supported-calendar-component-set": "VEVENT,VJOURNAL,VTODO",
        "tag": "VCALENDAR"
    },
    "def-addressbook": {
        "D:displayname": "Personal Address Book",
        "tag": "VADDRESSBOOK"
    }
  }

## Control with systemd
systemctl status radicale
