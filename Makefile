.PHONY: images debug clean-images all
.PRECIOUS: img/bmp/*

PATH := $(PATH):../go-nes/bin/

NAME=hero
NESCFG=nes_mmc5.cfg

CAFLAGS = -g -t nes --large-alignment
LDFLAGS = -C $(NESCFG) --dbgfile bin/$(NAME).dbg -m bin/$(NAME).map --large-alignment

ARROWS=up down left right up-pressed down-pressed left-pressed right-pressed
ARROWS_BMP = $(addsuffix .bmp,$(addprefix img/bmp/arrow-,$(ARROWS)))
ARROWS_CHR = $(addsuffix .chr,$(addprefix img/chr/arrow-,$(ARROWS)))

#BASES=turret orbital ground
#BASES_BMP = $(addsuffix .bmp,$(addprefix img/bmp/base-,$(BASES)))
#BASES_CHR = $(addsuffix .chr,$(addprefix img/chr/base-,$(BASES)))

include strats.mk

STRATS_LG_BMP=$(addsuffix _large.bmp,$(addprefix img/bmp/,$(STRATS)))
STRATS_LG_CHR=$(addsuffix _large.chr,$(addprefix img/chr/,$(STRATS)))

STRATS_SM_BMP=$(addsuffix _small.bmp,$(addprefix img/bmp/,$(STRATS)))
STRATS_SM_CHR=$(addsuffix _small.chr,$(addprefix img/chr/,$(STRATS)))

CHRLIST=$(ARROWS_CHR) \
		$(STRATS_LG_CHR) \
		$(STRATS_SM_CHR) \
		img/chr/numbers.chr \
		img/chr/font.chr \
		img/chr/font_inverted.chr \
		img/chr/menu_bg.chr

all: bin/ bin/$(NAME).nes
send: all
	./edlink-n8 bin/$(NAME).nes

images: $(CHRLIST)
debug:
	echo henlo

cleanall: clean clean-images

clean:
	-rm bin/* *.i

clean-images:
	-rm img/bmp/*.bmp img/chr/*.chr

bin/:
	-mkdir bin

bin/$(NAME).nes: bin/code.o bin/chr.o
	ld65 $(LDFLAGS) -o $@ $^

bin/chr.o: $(CHRLIST) chr_large.i chr_small.i
bin/code.o: strats.inc strats.rng.inc menu.inc
bin/%.o: %.asm
	ca65 $(CAFLAGS) -o $@ $<

img/chr/%_small.chr: img/bmp/%_small.bmp
	chrutil -o $@ $^

img/chr/menu_bg.chr menu.inc &: img/bmp/menu_bg.bmp
	chrutil -o img/chr/menu_bg.chr \
		--nt-ids menu.inc \
		--remove-duplicates $<

img/chr/%.chr: img/bmp/%.bmp
	chrutil -o $@ $^

img/bmp/%.bmp: img/%.aseprite
	aseprite -b $< --all-layers --save-as $@

$(ARROWS_BMP) &: img/arrows_16.aseprite
	aseprite -b --split-layers --filename-format 'img/bmp/{title}-{layer}.bmp' $< --save-as arrow
	#aseprite -b $< --ignore-layer 'Layer 1' --save-as img/bmp/arrow-{layer}.bmp

strat_small.chr: $(STRATS_SM_CHR)
	chrutil --remove-empty --remove-duplicates -o $@ $^

chr_large.i: $(STRATS_LG_BMP)
	truncate -s 0 $@
	for i in $(STRATS_LG_CHR) ; do \
		echo .incbin \"$$i\" >> $@; \
	done

chr_small.i: $(STRATS_SM_BMP)
	truncate -s 0 $@
	for i in $(STRATS_SM_CHR) ; do \
		echo .incbin \"$$i\" >> $@; \
	done

$(STRATS_LG_BMP) &: img/stratagems_large.aseprite
	aseprite -b \
		--split-layers \
		--filename-format 'img/bmp/{layer}_{title}.bmp' \
		$< --save-as large
	touch $(STRATS_LG_BMP)
	-rm img/bmp/done_large.bmp img/bmp/Background_large.bmp img/bmp/grp*.bmp

$(STRATS_SM_BMP) &: img/stratagems_32.aseprite
	aseprite -b \
		--split-layers \
		--filename-format 'img/bmp/{layer}_{title}.bmp' \
		$< --save-as small
	touch $(STRATS_SM_BMP)
	-rm img/bmp/done_large.bmp img/bmp/Background_large.bmp img/bmp/grp*.bmp

strats.rng.inc: rng.go
	go run rng.go
