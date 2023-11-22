#! /bin/bash
#
# Diffusion youtube avec ffmpeg
# Configurer youtube avec une résolution 720p. La vidéo n'est pas scalée.
#
# Ref: https://gist.github.com/olasd/9841772

VBR="2500k"                                    # Bitrate de la vidéo en sortie
FPS="30"                                       # FPS de la vidéo en sortie
QUAL="medium"                                  # Preset de qualité FFMPEG
YOUTUBE_URL="rtmp://mail.iveteran.me/live"
#YOUTUBE_URL="rtmp://localhost/live"

SOURCE="/home/yuu/yuu-screen-capture-2023-11-20.mkv"

#ffmpeg -v debug \
ffmpeg \
    -i "$SOURCE" \
    -filter:v "bwdif=mode=send_field:parity=auto:deint=all" \
    -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -r $FPS -g $(($FPS * 2)) -b:v $VBR \
    -acodec libmp3lame -ar 44100 -threads 6 -q:a 3 -b:a 712000 -bufsize 512k \
    -f flv "$YOUTUBE_URL"
