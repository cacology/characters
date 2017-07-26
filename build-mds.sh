#!/bin/bash

OUTFILE=${1#text/}
OUTFILE=${OUTFILE%/}

find -s $1 -name '*.md' -print0 | xargs -0 -I {} cat {} lib/pagebreak.md > build/character-mds/$OUTFILE.md
