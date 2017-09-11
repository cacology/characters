#!/usr/local/bin/bash
#we only want images 0010-0599, the last are endpapers, 590 images, sqrt (590)=24.3
#knows about the source files and uses channel 0

for hundreds in 0
do
    for tens in {1..9}
    do
        
convert ./source/000048649_0$[hundreds]$[tens]*.tif[0] -background none -compose blend -define compose:args=10,90 -flatten blend-$[hundreds]$[tens]0-$[hundreds]$[tens]9.tif

    done
done


for hundreds in {1..5}
do
    for tens in {0..9}
    do
        
convert ./source/000048649_0$[hundreds]$[tens]*.tif[0] -background none -compose blend -define compose:args=10,90 -flatten blend-$[hundreds]$[tens]0-$[hundreds]$[tens]9.tif

    done
done



