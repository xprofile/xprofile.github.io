# -*- coding: utf-8-unix -*-

CSS_FILES = $(wildcard *.css)
SOURCE = /Users/zengyajian/OneDrive/workspace
OUTPUT = notes
HEADER = css/header.md
FOOTER = css/footer.md

# Get all markdown files
DIRS := $(shell find $(SOURCE) -maxdepth 4 -type d)
FILES = $(foreach dir,$(DIRS),$(wildcard $(dir)/*.md))
HTMLS = $(patsubst $(SOURCE)/%.md,$(OUTPUT)/%.html, $(FILES))

# Get base path of all markdown files
BASE_DIRS := $(patsubst $(SOURCE)/%,$(OUTPUT)/%, $(DIRS))
HTML_DIRS := $(filter-out $(SOURCE),$(BASE_DIRS))

html-file-list = $(OUTPUT)/htmls.list

all: update-dir $(html-file-list) genindex

# Create output dirs for html files
update-dir:
	@mkdir -p $(HTML_DIRS)

$(html-file-list): $(HTMLS)
	@echo $(HTMLS) > $@

$(OUTPUT)/%.html: $(SOURCE)/%.md
	@echo "export ... $@"
	@pandoc $<       \
		-f markdown  \
		--mathjax    \
		--output=$@  \
		--to=html5   \
		-H $(HEADER) \
		--include-after-body=$(FOOTER) \
		--highlight-style=haddock \
		2> /dev/null

genindex: $(html-file-list)
	@echo "export ... index.html"
	@scripts/genindex -o index.html $< 1> /dev/null

clean:
	@rm -rf $(OUTPUT)/*
	@echo "...clean ok"

.PHONY: clean
