ffmpeg -f flv -listen 1 -i rtmp://0.0.0.0:1935/live -c copy -f flv rtmp://a.rtmp.youtube.com/live2/YOUR-KEY
# -analyzeduration is to make it start faster.
# "-re" flag means to "Read input at native frame rate.
#  Mainly used to simulate a grab device."
#  i.e. if you wanted to stream a video file,
#  then you would want to use this, otherwise it might stream it too fast
