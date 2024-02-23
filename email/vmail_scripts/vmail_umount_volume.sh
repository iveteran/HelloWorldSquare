#!/bin/env bash

#LOOP_FILE=/dev/loop-luks
LOOP_FILE=/dev/loop0
MAPPER_FILE=vmail_encrypted_file
MOUNT_POINT=/home/vmail/maildir

umount $MOUNT_POINT
cryptsetup luksClose $MAPPER_FILE
losetup -d $LOOP_FILE
#rmnod $LOOP_FILE
