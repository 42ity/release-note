# GNU Make syntax used below

OUTFILE = latest.json
PRODUCT = ipm
CONVERT = ./tools/convert.sh
JSONSH = ./JSON.sh/JSON.sh
INPUTS = $(shell ls -1 "$(PRODUCT)"/*.md)

EGREP = grep -E
ASPELL = aspell
ASPELL_LANG_ARG = en
ASPELL_LANG_ENV = en_US.UTF-8
# Must have a path component, goes to homedir otherwise
ASPELL_DICT = ./relnotes.dict
ASPELL_OUT_NOTERRORS = (^[ \t]*[\*\@]|^$$)

all: $(OUTFILE)

check: spellcheck check-json

clean:
	rm -f $(OUTFILE) $(addsuffix .spellchecked, $(INPUTS)) $(OUTFILE).checkedvalid
	# Interactive aspell leaves older copies of checked files; with Git we do not need them:
	rm -f $(addsuffix .bak, $(INPUTS))

$(OUTFILE): $(INPUTS)
	$(CONVERT) "$(PRODUCT)" "$(OUTFILE)"

check-json: $(OUTFILE).checkedvalid

$(OUTFILE).checkedvalid: $(OUTFILE)
	rm -f "$@"
	$(JSONSH) -N -P < "$<" >/dev/null && echo " JSON-OK    $<" >&2 || { echo " JSON-FAIL  $<" >&2 ; exit 1; }
	touch "$@"

spellcheck: $(addsuffix .spellchecked, $(INPUTS))

# Ported from NUT
%.spellchecked: %
	@rm -f "$@"
	@test -s "$<"
	@echo "  SPELLCHECK  $<" ; \
	 OUT="`(sed 's,^\(.*\)$$, \1,' | \
	 LANG=$(ASPELL_LANG_ENV) LC_ALL=$(ASPELL_LANG_ENV) \
	    $(ASPELL) -a -M -p "$(ASPELL_DICT)" \
	    -d "$(ASPELL_LANG_ARG)" --lang="$(ASPELL_LANG_ARG)" \
	    --ignore-accents --encoding=utf-8 \
	 ) < "$<"`" \
	 && { if test -n "$$OUT" ; then OUT="`echo "$$OUT" | $(EGREP) -b -v '$(ASPELL_OUT_NOTERRORS)' `" ; fi; \
	      test -z "$$OUT" ; } \
	 || { RES=$$? ; \
	      echo "FAILED : Aspell reported errors here:" >&2 \
	      && echo "----- vvv" >&2 \
	      && echo "$$OUT" >&2 \
	      && echo "----- ^^^" >&2 ; \
	      exit $$RES; }
	@touch "$@"

# Note: here we do not touch any files
spellcheck-interactive: $(INPUTS)
	@for F in $^ ; do \
	    echo "  SPELLCHECK-INTERACTIVE  $$F" ; \
	    LANG=$(ASPELL_LANG_ENV) LC_ALL=$(ASPELL_LANG_ENV) \
	        $(ASPELL) -c -M -p "$(ASPELL_DICT)" \
	        -d "$(ASPELL_LANG_ARG)" --lang="$(ASPELL_LANG_ARG)" \
	        --ignore-accents --encoding=utf-8 "$$F" ; \
	done
