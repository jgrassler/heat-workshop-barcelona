.PHONY: all clean

SVG := $(shell find img/ -name '*.svg')
DIA := $(shell find img/ -name '*.dia')
SVG_PNG := $(patsubst %.svg, %.png, $(SVG))
DIA_PNG := $(patsubst %.dia, %.PNG, $(DIA))
PNG :=  $(DIA_PNG) $(SVG_PNG)
PARTIALS:= partial/partial01-broken.yaml partial/partial01.yaml partial/partial02-broken.yaml partial/partial02.yaml partial/partial03.yaml partial/partial04.yaml partial/partial05.yaml partial/partial06-broken.yaml partial/partial06.yaml partial/partial07.yaml partial/partial08.yaml partial/partial09.yaml partial/partial10.yaml partial/partial11.yaml partial/partial12.yaml

presentation.odp: slides.md	template.odp $(PNG)
	odpdown \
	-p 1 \
	--content-master No-Logo_20_Content \
	--break-master Break \
	slides.md template.odp presentation.odp

presentation.pdf: presentation.odp
	libreoffice --convert-to pdf $<

all: presentation.odp presentation.pdf transcript.txt partial $(PARTIALS)

img/%.png: img/%.svg
	convert $< $@

# ugly, but will do
img/%.PNG: img/%.dia
	dia -e $@ -t svg $<

clean:
	rm -f presentation.odp
	rm -f img/*png
	rm -f img/*PNG
	rm -rf partial

transcript.txt: slides.md
	bin/htmlcomments slides.md > transcript.txt

partial:
	mkdir partial

partial/partial01-broken.yaml: snippets/with-errors/01*
	cat $^ > $@
partial/partial01.yaml: snippets/without-errors/01-*
	cat $^ > $@
partial/partial02-broken.yaml: partial/partial01.yaml snippets/with-errors/02-*
	cat $^ > $@
partial/partial02.yaml: partial/partial01.yaml snippets/without-errors/02-*
	cat $^ > $@
partial/partial03.yaml: partial/partial02.yaml snippets/without-errors/03-*
	cat $^ > $@
partial/partial04.yaml: partial/partial03.yaml snippets/without-errors/04-*
	cat $^ > $@
partial/partial05.yaml: partial/partial04.yaml snippets/without-errors/05-*
	cat $^ > $@
partial/partial06-broken.yaml: partial/partial05.yaml snippets/without-errors/09-*
	cat $^ > $@
partial/partial06.yaml: partial/partial05.yaml snippets/without-errors/06-*
	cat $^ > $@
partial/partial07.yaml: partial/partial06.yaml snippets/without-errors/07-*
	cat $^ > $@
partial/partial08.yaml: partial/partial07.yaml snippets/without-errors/08-*
	cat $^ > $@
partial/partial09.yaml: partial/partial08.yaml snippets/without-errors/09-*
	cat $^ > $@
partial/partial10.yaml: partial/partial09.yaml snippets/without-errors/10-*
	cat $^ > $@
partial/partial11.yaml: $(sort $(wildcard snippets/without-errors/0[1-4]-* snippets/without-errors/11-* snippets/without-errors/0[6-9]-* snippets/without-errors/10-*))
	cat $^ > $@
partial/partial12.yaml: partial/partial11.yaml snippets/without-errors/12-*
	cat $^ > $@
