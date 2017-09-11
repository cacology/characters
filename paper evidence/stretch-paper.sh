#!/usr/local/bin/bash
#level numbers from testing typical image
#$Red=81.6x92.5%
#$Green=71.0x85.9%
#$Blue=59.2x72.9%

#levels from testing average image, penultimate peak
#Red=83.1x88.6%
#Green=74.1x79.6%
#Blue=63.5x68.6%

#levels from testing average image, both final peaks
Red=82.4x92.2%
Green=73.3x83.6%
Blue=62.7x72.2%

for f in *.tif
do
    convert $f -channel R -level $Red -channel G -level $Green -channel B -level $Blue paper/paper-$f
done

