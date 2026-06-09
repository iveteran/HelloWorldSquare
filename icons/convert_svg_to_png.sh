# macOS: brew install librsvg
# Debian: apt install librsvg2-bin
#
# svg render tools: librsvg, resvg, imagemagick, inkscape
# NOTE: imagemagick在嵌套的svg图片中无法处理之间的相对位置
# inkscape -d 300 input.svg --export-filename=output.png

rsvg-convert -w 128 -h 128 terminal_waiting_sign.svg -o terminal_waiting_sign.png
rsvg-convert -w 128 -h 128 terminal_dollar_green_block_sign.svg -o terminal_dollar_green_block_sign.png
rsvg-convert -w 128 -h 128 terminal_greaterthen_green_block_sign.svg -o terminal_greaterthen_green_block_sign.png
