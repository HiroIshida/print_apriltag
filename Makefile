OPENSCAD_CHECK := $(shell command -v openscad 2> /dev/null)
PDFLATEX_CHECK := $(shell command -v pdflatex 2> /dev/null)


sizecm ?= 3
OUT := build/april_tag_print_$(sizecm)cm.pdf
all: check-deps $(OUT)

check-deps:
ifndef OPENSCAD_CHECK
	$(error "OpenSCAD is required. Please install: sudo apt install openscad")
endif
ifndef PDFLATEX_CHECK
	$(error "pdflatex is required. Please install: sudo apt install texlive-base")
endif

build/tag_with_margin.png: rotate_and_add_margin.py
	mkdir -p build
	python3 ./rotate_and_add_margin.py tag41_12_00000.png $@
	echo "Generated $@"

$(OUT): april_tag_print.tex build/tag_with_margin.png
	mkdir -p build
	pdflatex -output-directory=build '\def\sizecm{$(sizecm)}\input{$<}'
	mv build/april_tag_print.pdf $@
	echo "Generated $@"

clean:
	rm -rf build

.PHONY: all clean check-deps
