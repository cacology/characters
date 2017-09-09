target-texts := $(wildcard text/*/)
text-mds := $(wildcard build/text-mds/*.md)
target-analyses := $(wildcard analysis/*/)
analysis-mds := $(wildcard build/analysis-mds/*.md)
composite-mds := $(wildcard build/composite-mds/*.md)


character-mds-list : ; @echo $(text-mds)
target-characters-list : ; @echo $(target-texts)
target-analyses-list : ; @echo $(target-analyses)

.PHONY : all
all : build/mds
	$(MAKE) build/pdfs-from-mds build/html-from-mds build/tei-from-mds build/txt-from-mds build/docx-from-mds build/complete/text.pdf build/complete/text.html build/complete/text.xml build/complete/text.docx build/complete/text.txt build/complete/composite-text.html build/complete/composite-text.pdf index.md
	$(MAKE) clean

#insert a "pagebreak.md" between each page and name file better
text/%.mds :
	./build-text-mds.sh $(@D)

analysis/%.mds :
	./build-analysis-mds.sh $(@D)

# until pandoc is updated, manually alter the pipe character to \|
#[^\\] is not \ and \1 whatever that was 
index.md : index-source.md
	pandoc -f markdown -t markdown_github --smart index-source.md -o index.md
	sed -i '' 's/\([^\\]\)|/\1\\|/g' index.md

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
	cat $(text-mds) > $@

build/complete/composite-text.md :
	cat $(composite-mds) > $@

build/complete/text.pdf : build/complete/text.tex
	context --result=build/complete/text.pdf $<

build/complete/composite-text.pdf : build/complete/composite-text.tex
	context --result=build/complete/composite-text.pdf $<

build/mds : text
	$(MAKE) $(addsuffix text.mds, $(target-texts))
	$(MAKE) $(addsuffix analysis.mds, $(target-analyses))
	$(MAKE) build/remove-empty-mds
	./concatenate-composites.sh
	$(MAKE) build/remove-empty-mds
	touch build/mds

build/pdfs-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.pdf,$(text-mds))
	mv build/text-mds/*.pdf build/pdfs
	$(MAKE) $(subst .md,.pdf,$(composite-mds))
	mv build/composite-mds/*.pdf build/composite-pdfs
	touch build/pdfs-from-mds

build/html-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.html,$(text-mds))
	mv build/text-mds/*.html build/html
	$(MAKE) $(subst .md,.html,$(composite-mds))
	mv build/composite-mds/*.html build/composite-html
	touch build/html-from-mds

build/tei-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.xml,$(text-mds))
	mv build/text-mds/*.xml build/xml
	touch build/tei-from-mds

build/txt-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.txt,$(text-mds))
	mv build/text-mds/*.txt build/txt
	touch build/txt-from-mds

build/docx-from-mds : build/mds build/remove-empty-mds
	$(MAKE) $(subst .md,.docx,$(text-mds))
	mv build/text-mds/*.docx build/docx
	touch build/docx-from-mds

.PHONY : build/remove-empty-mds
build/remove-empty-mds :
	find build/text-mds -size -10c -delete
	find build/analysis-mds -size -10c -delete
	find build/composite-mds -size -10c -delete

.PHONY : clean
clean :
	find . \( -name "*.tex" -o -name "*.log" -o -name "*.tuc" \) -delete

.PHONY : cleanall
cleanall : clean
	find build/html \( -name "*.html" \) -delete
	find build/text-mds \( -name "*.md" \) -delete
	find build/analysis-mds \( -name "*.md" \) -delete
	find build/composite-mds \( -name "*.md" \) -delete
	find build \( -name mds -o -name pdfs-from-mds -o -name html-from-mds -o -name tei-from-mds -o -name txt-from-mds -o -name docx-from-mds \) -delete
	find build/pdfs \( -name "*.pdf" \) -delete
	find build/docx \( -name "*.docx" \) -delete
	find build/txt \( -name "*.txt" \) -delete
	find build/xml \( -name "*.xml" \) -delete
	find build/complete \( -name "*.pdf" -o -name "*.html" -o -name "*.md" -o -name "*.txt" -o -name "*.xml" -o -name "*.docx" \) -delete
	find . -name "index.md" -delete
