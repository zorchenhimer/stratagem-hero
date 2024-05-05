; asmsyntax=ca65

.segment "CHR00"

.align $400
.incbin "img/chr/arrow-up.chr"
.incbin "img/chr/arrow-down.chr"
.incbin "img/chr/arrow-left.chr"
.incbin "img/chr/arrow-right.chr"

.incbin "img/chr/font.chr"

.align $400
.incbin "img/chr/00-machine-gun_large.chr"
.incbin "img/chr/01-anti-material_large.chr"
.incbin "img/chr/02-stalwart_large.chr"
.incbin "img/chr/03-expendable-rocket_large.chr"
.incbin "img/chr/04-recoilless_large.chr"
.incbin "img/chr/05-flamethrower_large.chr"

.incbin "img/chr/29-emplacement_large.chr"

.repeat 4*16
    .repeat 16
        .byte 0
    .endrepeat
.endrepeat

