#!/usr/local/bin/bash
# makes every tif much smaller

ls *.tif | xargs -n 1 sh -c 'convert "$0"[0] -scale 10% "$0".jpg' 
