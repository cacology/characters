#!/usr/local/bin/bash

for f in scheme*0-outer.jpg
do
    convert $f -background white -gravity east -extent 1210x960 -background yellow -gravity west -extent 1220x960 border-$f
done

for f in scheme*1-inner.jpg
do
    convert $f -background white -gravity west -extent 1210x960 -background yellow -gravity east -extent 1220x960 border-$f
done
