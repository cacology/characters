target-characters := $(wildcard text/*/)
source-mds := $(wildcard character-mds/*.md)

test : ; @echo $(source-mds)

.PHONY : all
all : mds remove-empty-mds
	$(MAKE) pdfs-from-mds html-from-mds tei-from-mds txt-from-mds docx-from-mds complete/text.pdf complete/text.html complete/text.xml complete/text.docx complete/text.txt
	$(MAKE) clean

#insert a "pagebreak.md" between each page and name file better
%.mds :
	find $(@D) -name "*.md" -print | xargs -I % -L 1 cat % lib/pagebreak.md > character-mds/$(subst text/,,$(@D)).md

%.pdf : %.tex
	context --result=$@ $<

%.tex : %.md
	pandoc -s -f markdown -t context -o $@ $<

%.html : %.md
	pandoc -s -f markdown -t html5 -o $@ $<

%.xml : %.md
	pandoc -s -f markdown -t tei -o $@ $<

%.docx : %.md
	pandoc -s -f markdown -t docx -o $@ $<

%.txt : %.md
	pandoc -s -f markdown -t plain -o $@ $<

complete/text.md :
	cat $(source-mds) > $@

complete/text.pdf : complete/text.tex
	context --result=complete/text.pdf $<

mds : $(addsuffix character.mds, $(target-characters))
	touch mds

pdfs-from-mds : mds remove-empty-mds
	$(MAKE) $(subst .md,.pdf,$(source-mds))
	mv character-mds/*.pdf pdfs
	touch pdfs-from-mds

html-from-mds : mds remove-empty-mds
	$(MAKE) $(subst .md,.html,$(source-mds))
	mv character-mds/*.html html
	touch html-from-mds

tei-from-mds : mds remove-empty-mds
	$(MAKE) $(subst .md,.xml,$(source-mds))
	mv character-mds/*.xml xml
	touch tei-from-mds

txt-from-mds : mds remove-empty-mds
	$(MAKE) $(subst .md,.txt,$(source-mds))
	mv character-mds/*.txt txt
	touch txt-from-mds

docx-from-mds : mds remove-empty-mds
	$(MAKE) $(subst .md,.docx,$(source-mds))
	mv character-mds/*.docx docx
	touch docx-from-mds

.PHONY : remove-empty-mds
remove-empty-mds : mds
	find character-mds -size -10c -delete

.PHONY : clean
clean :
	find . \( -name "*.tex" -o -name "*.log" -o -name "*.tuc" \) -delete

.PHONY : cleanall
cleanall : clean
	find html \( -name "*.html" \) -delete
	find character-mds \( -name "*.md" \) -delete
	find . \( -name mds -o -name pdfs-from-mds -o -name html-from-mds -o -name tei-from-mds -o -name txt-from-mds -o -name docx-from-mds \) -delete
	find pdfs \( -name "*.pdf" \) -delete
	find complete \( -name "*.pdf" -o -name "*.html" -o -name "*.md" -o -name "*.txt" -o -name "*.xml" -o -name "*.docx" \) -delete
