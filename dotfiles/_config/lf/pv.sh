#!/bin/bash

file=$1
w=$2
h=$3
x=$4
y=$5

# 提取文件后缀并转为小写
extension=$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')
# 获取文件 MIME 类型
mimetype=$(file --mime-type -Lb "$file")

case "$mimetype" in
    # 文本文件：使用 bat (带语法高亮) 或 cat
    text/*|application/json|application/javascript)
        if command -v batcat > /dev/null; then
            batcat --style=numbers --color=always --terminal-width "$w" "$file"
        else
            cat "$file"
        fi
        ;;

    # 压缩包：查看内部清单
    application/zip)
        unzip -l "$file"
        ;;
    application/x-tar|application/x-gzip|application/x-bzip2)
        tar -tvf "$file"
        ;;

    # PDF 文件：使用 pdftotext
    application/pdf)
        if command -v pdftotext > /dev/null; then
            pdftotext "$file" -
        else
            echo "PDF content (install pdftotext to view)"
        fi
        ;;

    # 图片：如果在支持的终端下，可以使用 chafa 或 catimg 显示字符画
    image/*)
        if command -v timg > /dev/null; then
            #timg -p s "$file"
            timg -p s -g"${w}x${h}" --upscale=i "$file"
        elif command -v chafa > /dev/null; then
            chafa -s "${w}x${h}" "$file"
        else
            exiftool "$file" # 否则显示图片元数据
        fi
        ;;

    # 目录：使用 tree 或 ls
    inode/directory)
        if command -v tree > /dev/null; then
            tree -C "$file" | head -n 100
        else
            ls -F --color=always "$file"
        fi
        ;;

    # 默认处理
    *)
        echo "Binary file or unknown format"
        file -b "$file"
        ;;
esac
