#! /bin/bash
#
# Diffusion youtube avec ffmpeg
# Configurer youtube avec une résolution 720p. La vidéo n'est pas scalée.
#
# Ref: https://gist.github.com/olasd/9841772

VBR="2500k"                                    # Bitrate de la vidéo en sortie
FPS="30"                                       # FPS de la vidéo en sortie
QUAL="medium"                                  # Preset de qualité FFMPEG
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"  # URL de base RTMP youtube

#SOURCE="my_video.mp4"                          # Source video file
SOURCE="udp://239.255.139.0:1234"              # Source UDP (voir les annonces SAP)
KEY="...."

ffmpeg -v debug \
    -i "$SOURCE" -filter:v "bwdif=mode=send_field:parity=auto:deint=all" \
    -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -r $FPS -g $(($FPS * 2)) -b:v $VBR \
    -acodec libmp3lame -ar 44100 -threads 6 -qscale 3 -b:a 712000 -bufsize 512k \
    -f flv "$YOUTUBE_URL/$KEY"
