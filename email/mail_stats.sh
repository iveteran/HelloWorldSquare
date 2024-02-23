#!/bin/bash
#
# Daily Postfix Log report
#
MAILTO="admin@goe.works"
SUBJECT="Postfix log summary `date +%F`"

# Debain
journalctl _UID=`id -u postfix` -S yesterday -U today --no-pager | \
    pflogsumm --detail 10 --problems_first --verbose_msg_detail | \
    mutt -s "$SUBJECT" $MAILTO

# CentOS
pflogsumm -d yesterday /var/log/maillog \
    --problems-first --rej-add-from --verbose-msg-detail -q | \
    mutt -s "$SUBJECT" $MAILTO
