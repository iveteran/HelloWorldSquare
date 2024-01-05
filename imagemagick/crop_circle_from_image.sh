# Ref: https://legacy.imagemagick.org/discourse-server/viewtopic.php?t=30488
#      https://github.com/ImageMagick/ImageMagick/discussions/2169
#      https://stackoverflow.com/questions/41959355/how-can-i-combine-these-commands-to-achieve-circular-crop-in-imagemagick

demo_in_0() {
    convert logo: -alpha set -background none -fill white \
       \( +clone -channel A -evaluate set 0 +channel -draw "circle 400,200 400,100" \) \
       -compose dstin -composite crop_circle_in.png

    display crop_circle_in.png
}

demo_in() {
    convert logo: -alpha on -background none -fill white \
       \( +clone -channel A -evaluate multiply 0 +channel -draw "ellipse 153,128 57,57 0,360" \) \
       -compose DstIn -composite circle_in.png

    display circle_in.png
}

demo_out() {
    convert logo: -alpha on -background none -fill white \
       \( +clone -channel A -evaluate multiply 0 +channel -draw "ellipse 153,128 57,57 0,360" \) \
       -compose DstOut -composite circle_out.png

    display circle_out.png
}

demo_both() {
    convert logo: -alpha on -background none -fill white \
       \( +clone -channel A -evaluate multiply 0 +channel -draw "ellipse 153,128 57,57 0,360" \) \
       \( -clone 0,1 -compose DstOut -composite \) \
       \( -clone 0,1 -compose DstIn -composite \) \
       -delete 0,1 circle.png

    display circle-0.png
    display circle-1.png
}


demo_batch() {
    convert -size 200x200 xc:black -fill white -draw 'circle 100 100 100 1' -alpha copy mask.png
    for f in $(ls *.jpg)
    do
      convert $f -gravity center mask.png -compose copyopacity -composite -trim ${f}_output.png
      display ${f}_output.png
    done
}

demo_in_0
#demo_in
#demo_out
#demo_both
#demo_batch
