ffmpeg -i capture.mkv -i v-out-3-cropped-center-half.mp4 \
    -filter_complex "[0:v]scale=1920x1080,setpts=PTS-STARTPTS[bg]; [1:v]setpts=PTS-STARTPTS+2/TB, scale=-1:'480+600*abs(sin((t-2)*2*PI/8))':eval=frame[top]; [bg][top]overlay" \
    -vcodec libx264 \
    capture_zoompanning_2.mp4
