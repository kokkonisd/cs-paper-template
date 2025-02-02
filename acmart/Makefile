LATEXMK ?= $(shell which latexmk)
PAPER_SOURCE_DIR := $(realpath .)/src
BUILD_DIR := $(realpath .)/build

PAPER_MAIN := $(PAPER_SOURCE_DIR)/main.tex
PAPER_TARGET := $(BUILD_DIR)/main.pdf

DIFF_TARGET := $(BUILD_DIR)/diff.pdf

TARGETS := $(PAPER_TARGET)
PAPER_SOURCE_FILES := $(wildcard $(PAPER_SOURCE_DIR)/*.tex) $(wildcard $(PAPER_SOURCE_DIR)/**/*.tex)

OS := $(shell uname -s)


all: paper

paper: $(BUILD_DIR) $(PAPER_TARGET)

watch:
	$(MAKE) LATEXMK="$(shell which latexmk) -pvc" paper


$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)/

$(PAPER_TARGET): $(PAPER_MAIN) $(PAPER_SOURCE_FILES)

$(TARGETS):
	$(LATEXMK) -pdf -cd -interaction=nonstopmode -output-directory=$(BUILD_DIR)/ $<


open: $(PAPER_TARGET)
OPEN_TARGETS := open

$(OPEN_TARGETS):
ifeq ($(OS), Linux)
	xdg-open $^
else
	open $^
endif


clean:
	rm -rf $(BUILD_DIR)/


.PHONY: all clean open
