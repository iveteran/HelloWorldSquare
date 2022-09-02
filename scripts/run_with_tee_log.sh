#!/bin/sh

if [[ $# == 0 ]]; then
  echo "Usage: $0 <YOUR PROGRAM>"
  exit 1
fi

PROGRAM=$1
PROGRAM_WITH_ARGV=$*

LOG_FILE="${PROGRAM}_`date +%F_%T`.log"
$PROGRAM_WITH_ARGV | tee "log/$LOG_FILE"
