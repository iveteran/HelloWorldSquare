#!/bin/sh

#DATE=`date --iso-8601='seconds'`
DATE=`date +"%Y%m%d_%H%M%S"`
OUTPUT_FILE="yuu-screen-capture-${DATE}.mkv"
echo "output to $OUTPUT_FILE"

ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :0.0 -f pulse -ac 2 -i default $OUTPUT_FILE
