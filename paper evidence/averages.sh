#!/usr/local/bin/bash
#we only want images 0010-0599, the last are endpapers, 590 images, sqrt (590)=24.3
#knows about the source files and uses channel 0

for tens in {1..9}
do
    convert -average ./source/000048649_00$[tens]*.tif[0] average-0$[tens]0-0$[tens]9.tif
done

for hundreds in {1..5}
do
    for tens in {0..9}
do
    convert -average ./source/000048649_0$[hundreds]$[tens]*.tif[0] average-$[hundreds]$[tens]0-$[hundreds]$[tens]9.tif
    done
done



