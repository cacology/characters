target-characters := $(wildcard text/*/)
source-mds := $(wildcard build/character-mds/*.md)

test : ; @echo $(source-mds)

.PHONY : all
all : build/mds build/remove-empty-mds
	$(MAKE) build/pdfs-from-mds build/html-from-mds build/tei-from-mds build/txt-from-mds build/docx-from-mds build/complete/text.pdf build/complete/text.html build/complete/text.xml build/complete/text.docx build/complete/text.txt
	$(MAKE) clean

#insert a "pagebreak.md" between each page and name file better
%.mds :
#experiment in creating unique ids for md, but pre-parsing causes problems
#	find $(@D) -name "*.md" -print | xargs -I % -L 1 pandoc -t markdown --id-prefix $(@D) % lib/pagebreak.md > character-mds/$(subst text/,,$(@D)).md
	find $(@D) -name "*.md" -print0 | xargs -0 -I {file} -L 1 cat {file} lib/pagebreak.md > build/character-mds/$(subst text/,,$(@D)).md

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

build/complete/text.md :
	cat $(source-mds) > $@

build/complete/text.pdf : build/complete/text.tex
	context --result=build/complete/text.pdf $<

build/mds : text
	$(MAKE) $(addsuffix character.mds, $(target-characters))
	touch build/mds

build/pdfs-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.pdf,$(source-mds))
	mv build/character-mds/*.pdf build/pdfs
	touch build/pdfs-from-mds

build/html-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.html,$(source-mds))
	mv build/character-mds/*.html build/html
	touch build/html-from-mds

build/tei-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.xml,$(source-mds))
	mv build/character-mds/*.xml build/xml
	touch build/tei-from-mds

build/txt-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.txt,$(source-mds))
	mv build/character-mds/*.txt build/txt
	touch build/txt-from-mds

build/docx-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.docx,$(source-mds))
	mv build/character-mds/*.docx build/docx
	touch build/docx-from-mds

.PHONY : build/remove-empty-mds
build/remove-empty-mds : build/mds
	find build/character-mds -size -10c -delete

.PHONY : clean
clean :
	find . \( -name "*.tex" -o -name "*.log" -o -name "*.tuc" \) -delete

.PHONY : cleanall
cleanall : clean
	find build/html \( -name "*.html" \) -delete
	find build/character-mds \( -name "*.md" \) -delete
	find build \( -name mds -o -name pdfs-from-mds -o -name html-from-mds -o -name tei-from-mds -o -name txt-from-mds -o -name docx-from-mds \) -delete
	find build/pdfs \( -name "*.pdf" \) -delete
	find build/complete \( -name "*.pdf" -o -name "*.html" -o -name "*.md" -o -name "*.txt" -o -name "*.xml" -o -name "*.docx" \) -delete
