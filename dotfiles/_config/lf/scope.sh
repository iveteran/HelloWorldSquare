#!/usr/bin/env bash

# @author nate zhou
# @since 2025
# general file previewer for LF & FZF
# `~/.local/bin/fzf-scope` is a modified version of my `lf/scope`

file=$1
w=$2
h=$3
x=$4
y=$5

## save a cache file for faster preview
[ -d "$HOME/.cache/lf" ] || mkdir "$HOME/.cache/lf"

show_img(){
    #if [ -n "$FZF_LEVEL" ] || [ -n "$NVIM" ] || [ -n "$DVTM" ]; then
    #    #catimg -t -w 80 "$file" # use catimg when running with `fzf` & `lf.vim`
    if command -v timg > /dev/null; then
        timg -p s -g"${w}x${h}" --upscale=i "$file"
    elif [ "$XDG_SESSION_TYPE" != "tty" ]; then
        /usr/bin/chafa -f sixel\
                       -s "$wx$h" \
                       --animate off \
                       --polite on \
                       -t 1 \
                       --bg '#111111' \
                       "$file"
    else
        # catimg is faster than chafa for ANSI
        catimg -t -w "$w" "$file"
    fi
}

mimetype=$(file -Lb --mime-type "$file")
case "$mimetype" in
    image/*xcf|image/heic|image/x-xpixmap)
        # create a cache for every file, if 2 files have the same
        # size+name+last_modified_date, it has the same hash
        # `shasum` is faster than other `sha*sum`
        CACHE="$HOME/.cache/lf/$(stat --printf '%s%n%Y' "$(readlink -f "$file")" \
                               | shasum | cut -d' ' -f1)"
        [ -f "${CACHE}.jpg" ] || convert "$file" -flatten \
                                              -quality 50 "${CACHE}.jpg"
        show_img "${CACHE}.jpg" "$w" "$h"
        ;;
    image/*)
        show_img "$file" "$w" "$h"
        ;;
    video/*)
        CACHE="$HOME/.cache/lf/$(stat --printf '%s%n%Y' "$(readlink -f "$file")" \
                               | shasum | cut -d' ' -f1)"
        [ -f "${CACHE}.jpg" ] \
            || /usr/bin/ffmpegthumbnailer -i "$file" -s 480 -q 5 -o "${CACHE}.jpg"
        show_img "${CACHE}.jpg" "$w" "$h"
        ;;
    audio/*)
        mid3v2 -l "$file"
        ;;
    application/epub+zip)
        CACHE="$HOME/.cache/lf/$(stat --printf '%s%n%Y' "$(readlink -f "$file")" \
                               | shasum | cut -d' ' -f1)"
        [ -f "${CACHE}.png" ] \
            || /usr/bin/gnome-epub-thumbnailer "$file" "$CACHE".png
        show_img "$CACHE".png "$w" "$h"
        ;;
    application/pdf)
        CACHE="$HOME/.cache/lf/$(stat --printf '%s%n%Y' "$(readlink -f "$file")" \
                               | shasum | cut -d' ' -f1)"
        # `pdftoppm` already adds `.jpg` extension, don't duplicate
        [ -f "${CACHE}.jpg" ] \
            || /usr/bin/pdftoppm -f 1 -l 1 -singlefile -jpeg "$file" "$CACHE"
        show_img "$CACHE".jpg "$w" "$h"
        ;;
    application/zip|application/vnd.android.package-archive)
        zipinfo "$file" | "$PAGER"
        ;;
    application/gzip)
        case "$file" in
            *tar.gz)
                tar vvtf "$file" | "$PAGER"
                ;;
            *)
                zless "$file" | "$PAGER"
            ;;
        esac
        ;;
    application/x-7z-compressed)
        7z l -ba "$file" | grep -oP '\S+$' | "$PAGER"
        ;;
    application/*tar|application/*zip*|application/zstd|application/*xz)
        tar vvtf "$file" | "$PAGER"
        ;;
    application/vnd.rar)
        unrar -t "$file" | tail +8 | "$PAGER"
        ;;
    application/x-bittorrent)
        /usr/bin/transmission-show "$file" | "$PAGER"
        ;;
    application/x-iso*)
        # `iso-info` command from `libcdio`
        iso-info "$file" | "$PAGER"
        ;;
    application/*opendocument*)
        odt2txt "$file";
        ;;
    application/octet-stream)
        file -b "$file"
        ;;
    message/rfc822)
        "$PAGER" "$file"
        ;;
    text/troff)
        man -l "$file"
        ;;
    text/html)
        firejail --net=none w3m "$file"
        ;;
    text/*|application/pgp-signature|application/pgp-keys|application/javascript|application/json)
        batcat --style=numbers --color=always --terminal-width "$w" "$file"
        ;;
    inode/directory)
        command du -aLhd1 "$file" 2> /dev/null | sort -rh
        ;;
    # 默认处理
    *)
        echo "Binary file or unknown format"
        file -b "$file"
        ;;
esac
