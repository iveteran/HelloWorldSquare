#! /bin/bash

ffmpeg -framerate 30 \
    -video_size 1920x1080 \
    -f x11grab \
    -i :0.0 \
    -f pulse \
    -i default \
    -c:v libx264 \
    -b:v 5000k \
    -maxrate 5000k \
    -bufsize 10000k \
    -g 60 \
    -vf format=yuv420p \
    -c:a aac \
    -b:a 128k \
    -f flv \
    rtmp://mail.iveteran.me/live
