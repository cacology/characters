all: A_Huffing_Courtier.pdf A_Huffing_Courtier.html
.PHONY : all

%.pdf : %.tex
	context $<

%.tex : %.md
	pandoc -s -f markdown -t context -o $@ $<

%.html : %.md
	pandoc -s -f markdown -t html5 -o $@ $<

A_Huffing_Courtier.md :
	ls A_Huffing_Courtier_08[0-5].md | xargs -I % -L 1 cat % ../../lib/pagebreak.md > A_Huffing_Courtier.md

.PHONY : clean
clean :
	find . \( -name "*.pdf" -o -name "*.tex" -o -name "A_Huffing_Courtier.md" -o -name "*.log" \) -delete
