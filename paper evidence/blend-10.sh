#!/usr/local/bin/bash
#blend 10 images at a time

ls *.tif | xargs -n 10 sh -c 'convert "$@" -background none -compose blend -define compose:args=10,90 -flatten blend-"$0".tif'
