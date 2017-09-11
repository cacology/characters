#!/usr/local/bin/bash
# trim black border
# crop images to $1 (300x470)
# then stack images into octavo schemes, inner and outer

ls *.jpg | xargs -n 1 sh -c 'convert "$0" -fuzz 1% -trim trim-"$0"'

ls trim-*.jpg | xargs -n 1 sh -c 'convert "$1" -gravity center -background none -extent "$0" crop-"$1"' $1

#grab 16 images at a time and put the two schemes together
ls crop-*.jpg | xargs -n 16 sh -c \
                      'convert \( \
                                \( "$4" -rotate 180 \) \
                                \( "${11}" -rotate 180 \) \
                                \( "$8" -rotate 180 \) \
                                \( "$7" -rotate 180 \) +append \
                                   -background none \) \
                               \( "$3" "${12}" "${15}" "$0" +append \
                                   -background none \) \
                      -append -background none scheme-"$0"-0-outer.jpg;
                       convert \( \
                                \( "$6" -rotate 180 \) \
                                \( "$9" -rotate 180 \) \
                                \( "${10}" -rotate 180 \) \
                                \( "$5" -rotate 180 \) +append \
                                   -background none \) \
                               \( "$1" "${14}" "${13}" "$2" +append \
                                  -background none \) \
                      -append -background none scheme-"$0"-1-inner.jpg'


rm crop-*.jpg
rm trim-*.jpg
