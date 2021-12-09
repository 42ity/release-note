# GNU Make syntax used below

OUTFILE = latest.json
PRODUCT = ipm
CONVERT = ./tools/convert.sh

INPUTS = $(shell ls -1 "$(PRODUCT)"/*.md)

all: $(OUTFILE)

$(OUTFILE): $(INPUTS)
	$(CONVERT) "$(PRODUCT)" "$(OUTFILE)"
