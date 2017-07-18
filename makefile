target-characters := $(wildcard text/*/)
source-mdxs := $(wildcard mdxs/*.mdx)

listtarget-characters : ; @echo $(target-characters)
test : ; @echo $(addsuffix $(subst text/,,$(@D)).mdx,$(target-characters))

all: pdfs-from-mdxs html-from-mdxs
.PHONY : all

#insert a "pagebreak.md" between each page and name file better
%.mdx :
	ls $(@D)/*[0-9].md | xargs -I % -L 1 cat % lib/pagebreak.md > mdxs/$(subst text/,,$(@D)).mdx

%.pdf : %.tex
	context $<

%.tex : %.md
	pandoc -s -f markdown -t context -o $@ $<

%.tex : %.mdx
	pandoc -s -f markdown -t context -o $@ $<

%.html : %.md
	pandoc -s -f markdown -t html5 -o $@ $<

%.html : %.mdx
	pandoc -s -f markdown -t html5 -o $(subst mdxs,html,$@) $<


complete/text.md :
	cat $(source-mdxs) > $@

complete/text.pdf : complete/text.tex
	context --result=complete/text.pdf $<

#complete/text.html : complete/text.md
#	context --result=complete/text.html $<

.PHONY : mdxs
mdxs : $(addsuffix character.mdx, $(target-characters))

.PHONY : pdfs-from-mdxs
pdfs-from-mdxs :
	$(MAKE) $(subst .mdx,.pdf,$(source-mdxs))
	mv *.pdf pdfs

.PHONY : html-from-mdxs
html-from-mdxs :
	$(MAKE) $(subst .mdx,.html,$(source-mdxs))

.PHONY : clean
clean :
	find . \( -name "*.tex" -o -name "*.log" -o -name "*.tuc" \) -delete

.PHONY : cleanall
cleanall : clean
	find html \( -name "*.html" \) -delete
	find mdxs \( -name "*.mdx" \) -delete
	find pdfs \( -name "*.pdf" \) -delete
	find complete \( -name "*.pdf" -o -name "*.html" \) -delete
