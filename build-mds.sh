#!/bin/bash

OUTFILE=${1#text/}
OUTFILE=${OUTFILE%/}

find $1 -name '*.md' -print | sort | xargs -I {} cat {} lib/pagebreak.md > build/character-mds/$OUTFILE.md
