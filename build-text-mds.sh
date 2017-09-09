#!/bin/bash

OUTFILE=${1#text/}
OUTFILE=${OUTFILE%/}

find $1 -name '*.md' -print0 | sort -z | xargs -0 -J {} cat {} lib/pagebreak.md > build/text-mds/$OUTFILE.md
