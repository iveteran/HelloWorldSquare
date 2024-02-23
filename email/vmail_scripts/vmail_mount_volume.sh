#!/bin/env bash

#LOOP_FILE=/dev/loop-luks
LOOP_FILE=/dev/loop0
VOLUME_FILE=/home/vmail/volume/vmail_encrypted_volume
VOLUME_KEY_FILE=/home/vmail/volume/vmail-volume-key
MAPPER_FILE=vmail_encrypted_file
MOUNT_POINT=/home/vmail/maildir
CHECK_PERIOD=60
FAIL_CHECK_PERIOD=5

while true
do
  if [ -e $MOUNT_POINT/lost+found ]; then
    echo "vmail volume already mounted, do nothing, to check in next $CHECK_PERIOD seconds again"
    sleep $CHECK_PERIOD
  else
    if [ ! -e $LOOP_FILE ]; then
        mknod $LOOP_FILE b 7 0
    fi
    losetup -l | grep -q $VOLUME_FILE
    if [ ! $? -eq 0 ]; then
    	losetup $LOOP_FILE $VOLUME_FILE
    fi
    if [ ! -e /dev/mapper/$MAPPER_FILE ]; then
        cryptsetup luksOpen $LOOP_FILE $MAPPER_FILE --key-file $VOLUME_KEY_FILE
    fi 
    mount /dev/mapper/$MAPPER_FILE $MOUNT_POINT && \
    chown -R vmail:vmail $MOUNT_POINT
    if [ $? -eq 0 ]; then
        echo "vmail volume mount success"
    else
        echo "vmail volume mount fail, try in next $FAIL_CHECK_PERIOD seconds"
        sleep $FAIL_CHECK_PERIOD
    fi
  fi
done
