#!/usr/local/bin/bash
#average 10 images at a time

ls *.tif | xargs -n 10 sh -c 'convert "$@" -average -"$0".tif'
