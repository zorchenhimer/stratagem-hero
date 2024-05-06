.PHONY: images debug clean-images all

PATH := $(PATH):../go-nes/bin/

NAME=hero
NESCFG=nes_mmc5.cfg

CAFLAGS = -g -t nes --large-alignment
LDFLAGS = -C $(NESCFG) --dbgfile bin/$(NAME).dbg -m bin/$(NAME).map --large-alignment

ARROWS=up down left right
ARROWS_BMP = $(addsuffix .bmp,$(addprefix img/bmp/arrow-,$(ARROWS)))
ARROWS_CHR = $(addsuffix .chr,$(addprefix img/chr/arrow-,$(ARROWS)))

#BASES=turret orbital ground
#BASES_BMP = $(addsuffix .bmp,$(addprefix img/bmp/base-,$(BASES)))
#BASES_CHR = $(addsuffix .chr,$(addprefix img/chr/base-,$(BASES)))

include strats.mk

STRATS_LG_BMP=$(addsuffix _large.bmp,$(addprefix img/bmp/,$(STRATS)))
STRATS_LG_CHR=$(addsuffix _large.chr,$(addprefix img/chr/,$(STRATS)))

CHRLIST=$(ARROWS_CHR) $(STRATS_LG_CHR) img/chr/numbers.chr img/chr/font.chr

all: bin/ bin/$(NAME).nes

images: $(CHRLIST)
debug:
	echo $(STRATS_LG_CHR)

clean-images:
	-rm img/bmp/*.bmp img/chr/*.chr

bin/:
	-mkdir bin

bin/$(NAME).nes: bin/code.o bin/chr.o
	ld65 $(LDFLAGS) -o $@ $^

bin/chr.o: $(CHRLIST)
bin/code.o: strats.inc
bin/%.o: %.asm
	ca65 $(CAFLAGS) -o $@ $<

img/chr/%.chr: img/bmp/%.bmp
	chrutil -o $@ $^

img/bmp/%.bmp: img/%.aseprite
	aseprite -b $< --all-layers --save-as $@

$(ARROWS_BMP) &: img/arrows_16.aseprite
	aseprite -b --split-layers --filename-format 'img/bmp/{title}-{layer}.bmp' $< --save-as arrow
	#aseprite -b $< --ignore-layer 'Layer 1' --save-as img/bmp/arrow-{layer}.bmp

#$(BASES_BMP) &: img/stratagems.aseprite
#	aseprite -b \
#		--split-layers \
#		--filename-format 'img/bmp/{title}-{layer}.bmp' \
#		$< --save-as base

$(STRATS_LG_BMP) &: img/stratagems_large.aseprite
	aseprite -b \
		--split-layers \
		--filename-format 'img/bmp/{layer}_{title}.bmp' \
		$< --save-as large
	touch $(STRATS_LG_BMP)
