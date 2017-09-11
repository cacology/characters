#!/usr/local/bin/bash
# cropy images to $1 (300x470 for average images mosaic)
# then stack images $2 at a time horizontally, then vertically

ls *.jpg | xargs -n 1 sh -c 'convert "$1" -gravity center -extent "$0" crop-"$1"' $1

ls crop-*.jpg | xargs -n $2 sh -c 'convert "$0" "$@" -background none +append row-"$0"'

convert row-*.jpg -background none -append mosaic.jpg

rm row-*.jpg
rm crop-*.jpg
