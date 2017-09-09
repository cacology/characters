#!/bin/bash

OUTFILE=${1#analysis/}
OUTFILE=${OUTFILE%/}

find $1 -name '*.md' -print0 | sort -z | xargs -0 -J {} cat {} lib/pagebreak.md > build/analysis-mds/$OUTFILE.md
