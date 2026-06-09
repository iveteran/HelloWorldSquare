# macOS: brew install librsvg
# Debian: apt install librsvg2-bin

WIDTH=1024
HEIGHT=1024
BORDER_PCT=10
SIZE_PCT=$((100-BORDER_PCT))

function convert {
    local filename=$1
    rsvg-convert -w $WIDTH -h $HEIGHT ${filename}.svg -o ${filename}.png
}

function convert_with_border {
    local filename=$1
    rsvg-convert -w $WIDTH -h $HEIGHT ${filename}.svg | \
        magick png:- \
        -resize ${SIZE_PCT}% \
        -background none \
        -gravity center \
        -extent ${WIDTH}x${HEIGHT} \
        ${filename}-border-${BORDER_PCT}.png
}

convert "matrix-icc-blue"
convert "matrix-icm-blue"

convert_with_border "matrix-icc-blue"
convert_with_border "matrix-icm-blue"
