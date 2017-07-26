#!/bin/bash

find $1 -name '*.md' -print0 | xargs -0 -I % -L 1 cat % lib/pagebreak.md > build/character-mds/${1#text/}.md
