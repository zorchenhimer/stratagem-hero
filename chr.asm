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
.incbin "img/chr/06-autocannon_large.chr"
.incbin "img/chr/07-heavy-mg_large.chr"
.incbin "img/chr/08-airburst_large.chr"
.incbin "img/chr/09-railgun_large.chr"
.incbin "img/chr/10-spear_large.chr"
.incbin "img/chr/11-gatling-barrage_large.chr"
.incbin "img/chr/12-airburst_large.chr"
.incbin "img/chr/13-120mm_large.chr"
.incbin "img/chr/14-380mm_large.chr"
.incbin "img/chr/15-walking-barrage_large.chr"

.incbin "img/chr/29-emplacement_large.chr"

.repeat 4*16
    .repeat 16
        .byte 0
    .endrepeat
.endrepeat

