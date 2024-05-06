; asmsyntax=ca65

.segment "CHR00"

.align $400
.incbin "img/chr/arrow-up.chr"
.incbin "img/chr/arrow-down.chr"
.incbin "img/chr/arrow-left.chr"
.incbin "img/chr/arrow-right.chr"

.incbin "img/chr/font.chr"

.align $400
.include "chr.i"

.repeat 4*16
    .repeat 16
        .byte 0
    .endrepeat
.endrepeat

