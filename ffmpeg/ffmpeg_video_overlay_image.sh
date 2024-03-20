ffmpeg -i bg.jpg -i video.mp4 -filter_complex "[1]scale=-1:300[vid]; [0]scale=1200:720[img]; [img][vid] overlay=(W-w)/2:(H-h)/2" -acodec copy -preset ultrafast test.mp4
