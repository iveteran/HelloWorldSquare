# Ref: https://legacy.imagemagick.org/discourse-server/viewtopic.php?t=30488
#      https://github.com/ImageMagick/ImageMagick/discussions/2169
#      https://stackoverflow.com/questions/41959355/how-can-i-combine-these-commands-to-achieve-circular-crop-in-imagemagick

demo_in_0() {
    local radius=200
    local center_x=400
    local center_y=200
    local x1=`expr $center_x+$radius`
    local y1=$center_y
    # NOTE: x1,y1 is any point in the circle

    convert logo: -alpha set -background none -fill white \
       \( +clone -channel A -evaluate set 0 +channel -draw "circle $center_x,$center_y $x1,$y1" \) \
       -compose dstin -composite crop_circle_in.png

    display crop_circle_in.png
}

demo_in() {
    local ox=153      # Offset X, distance from the center of the ellipse till the left border of the image
    local oy=128      # Offset Y, distance from the center of the ellipse till the top of the image
    local rx=57       # X radius
    local ry=57       # Y radius
    local start=0     # Starting angle in degrees.
    local end=360     # End angle in degrees.
    convert logo: -alpha on -background none -fill white \
       \( +clone -channel A -evaluate multiply 0 +channel -draw "ellipse $ox,$oy $rx,$ry $start,$end" \) \
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
