#!/bin/bash

for file in ./build/analysis-mds/*.md ; do
    cat $file ${file/analysis-mds/text-mds} > ./build/composite-mds/${file#./build/analysis-mds}
done
                     
