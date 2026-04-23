#!/bin/bash
# Install tools and chinese fonts:
#   sudo apt install texlive-xetex texlive-lang-chinese fonts-noto-cjk pandoc

#FILENAME="我的文档"
FILENAME="../markdown_slides_example"
TODAY=$(date '+%Y年%m月%d日')

pandoc $FILENAME.md \
    -o $FILENAME.pdf \
    --defaults=pandoc_style_template.yaml \
    -M date=$TODAY
