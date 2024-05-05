    .word :+
    .word :++
    .word :+++
    .word :++++
    .word :+++++
    .word :++++++
    .word :+++++++
    .word :++++++++
    .word :+++++++++
    .word :++++++++++
    .word :+++++++++++
    .word :++++++++++++
    .word :+++++++++++++
    .word :++++++++++++++
    .word :+++++++++++++++
    .word :++++++++++++++++
    .word :+++++++++++++++++
    .word :++++++++++++++++++
    .word :+++++++++++++++++++
    .word :++++++++++++++++++++
    .word :+++++++++++++++++++++
    .word :++++++++++++++++++++++
    .word :+++++++++++++++++++++++
    .word :++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    .word :+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

.charmap '_', 0
.charmap 'U', 1
.charmap 'D', 2
.charmap 'L', 3
.charmap 'R', 4

charnum .set 5
.repeat 10, i
    .charmap i+$30, i+$10
    endnum .set (i+charnum)
    .out .sprintf("charmap %02X, %02X", i+$30, (i+charnum))
.endrepeat

charnum .set charnum
.repeat 26, i
    .charmap i+$61, i+$1A
    .out .sprintf("charmap %02X, %02X", i+$61, (i+$0F))
    endnum .set (i+charnum)
.endrepeat

.charmap '-', $34
.charmap '/', $35
.charmap '"', $36
.charmap ' ', $37

.out .sprintf("charnum: %d", charnum)
.out .sprintf("endnum: %d", endnum)

:   .byte StratPal::Blue
    .byte "__DLDUR_"
    .asciiz "mg-43 machine gun"

:   .byte StratPal::Blue
    .byte "__DLRUD_"
    .asciiz "apw-1 anti-materiel rifle"

:   .byte StratPal::Blue
    .byte "_DLDUUL_"
    .asciiz "m-105 stalwart"

:   .byte StratPal::Blue
    .byte "__DDLUR_"
    .asciiz "eat-17 expendable anti-tank"

:   .byte StratPal::Blue
    .byte "__DLRRL_"
    .asciiz "gr-8 recoilless rifle"

:   .byte StratPal::Blue
    .byte "__DLUDU_"
    .asciiz "flam-40 flamethrower"

:   .byte StratPal::Blue
    .byte "_DLDUUR_"
    .asciiz "ac-8 autocannon"

:   .byte StratPal::Blue
    .byte "__DLUDD_"
    .asciiz "mg-206 heavy machine gun"

:   .byte StratPal::Blue
    .byte "__DUULR_"
    .asciiz "rl-77 airburst rocket"

:   .byte StratPal::Blue
    .byte "_DRDULR_"
    .asciiz "rs-422 railgun"

:   .byte StratPal::Blue
    .byte "__DDUDD_"
    .asciiz "faf-14 spear"

:   .byte StratPal::Red
    .byte "__RDLUU_"
    .asciiz "orbital gatling barrage"

:   .byte StratPal::Red
    .byte "___RRR__"
    .asciiz "orbital airburst strike"

:   .byte StratPal::Red
    .byte "_RRDLRD_"
    .asciiz "orbital 120mm he barrage"

:   .byte StratPal::Red
    .byte "_LDUULDD"
    .asciiz "orbital 380mm he barrage"

:   .byte StratPal::Red
    .byte "_RDRDRD_"
    .asciiz "orbital walking barrage"

:   .byte StratPal::Red
    .byte "__RDURD_"
    .asciiz "orbital laser"

:   .byte StratPal::Red
    .byte "__RUDDR_"
    .asciiz "orbital railcannon stike"

:   .byte StratPal::Red
    .byte "___URR__"
    .asciiz "eagle strafing run"

:   .byte StratPal::Red
    .byte "__URDR__"
    .asciiz "eagle airstrike"

:   .byte StratPal::Red
    .byte "__URDDR_"
    .asciiz "eagle cluster bomb"

:   .byte StratPal::Red
    .byte "__URDU__"
    .asciiz "eagle napalm airstrike"

:   .byte StratPal::Blue
    .byte "__DUUDU_"
    .asciiz "lift-850 jump pack"

:   .byte StratPal::Red
    .byte "__URUD__"
    .asciiz "eagle smoke strike"

:   .byte StratPal::Red
    .byte "__URUL__"
    .asciiz "eagle 110mm rocket pods"

:   .byte StratPal::Red
    .byte "__URDDD_"
    .asciiz "eagle 500kg bomb"

:   .byte StratPal::Red
    .byte "___RRU__"
    .asciiz "orbital precision strike"

:   .byte StratPal::Red
    .byte "__RRDR__"
    .asciiz "orbital gas strike"

:   .byte StratPal::Red
    .byte "__RRLD__"
    .asciiz "orbital ems strike"

:   .byte StratPal::Red
    .byte "__RRDU__"
    .asciiz "orbital smoke strike"

:   .byte StratPal::Green
    .byte "_DULRRL_"
    .asciiz "e/mg-100 hmg emplacement"

:   .byte StratPal::Green
    .byte "_DDLRLR_"
    .asciiz "fx-12 shield generator relay"

:   .byte StratPal::Green
    .byte "_DURULR_"
    .asciiz "a/arc-3 tesla tower"

:   .byte StratPal::Green
    .byte "__DLUR__"
    .asciiz "md-6 anti-personnel minefield"

:   .byte StratPal::Blue
    .byte "_DLDUUR_"
    .asciiz "b-1 supply pack"

:   .byte StratPal::Blue
    .byte "__DLULD_"
    .asciiz "gl-21 grenade launcher"

:   .byte StratPal::Blue
    .byte "__DLDUL_"
    .asciiz "las-98 laser cannon"

:   .byte StratPal::Green
    .byte "__DLLD__"
    .asciiz "md-i4 incendiary mines"

:   .byte StratPal::Blue
    .byte "_DULURR_"
    .byte "ax/las-5 ", '"', "guard dog", '"', " rover", $00

:   .byte StratPal::Blue
    .byte "_DLDDUL_"
    .asciiz "sh-20 ballistic shield backpack"

:   .byte StratPal::Blue
    .byte "_DRDULL_"
    .asciiz "arc-3 arc thrower"

:   .byte StratPal::Blue
    .byte "__DDULR_"
    .asciiz "las-99 quasar cannon"

:   .byte StratPal::Blue
    .byte "__DULRLR_"
    .asciiz "sh-32 shield generator pack"

:   .byte StratPal::Green
    .byte "__DURRU_"
    .asciiz "a/mg-43 machine gun sentry"

:   .byte StratPal::Green
    .byte "__DURL__"
    .asciiz "a/g-16 gatling sentry"

:   .byte StratPal::Green
    .byte "__DURRD_"
    .asciiz "a/m-12 mortar sentry"

:   .byte StratPal::Green
    .byte "_DULURD_"
    .byte "ax/ar-23 ", '"', "guard dog", '"', $00

:   .byte StratPal::Green
    .byte "_DURULU_"
    .asciiz "a/ac-8 autocannon sentry"

:   .byte StratPal::Green
    .byte "__DURRL_"
    .asciiz "a/mls-4x rocket sentry"

:   .byte StratPal::Green
    .byte "__DURDR_"
    .asciiz "a/m-23 ems mortar sentry"

:   .byte StratPal::Blue
    .byte "_LDRULDD"
    .asciiz "exo-45 patriot exosuit"

:   .byte StratPal::Yellow
    .byte "__UDRLU_"
    .asciiz "reinforce"

:   .byte StratPal::Yellow
    .byte "__UDRU__"
    .asciiz "sos beacon"

:   .byte StratPal::Yellow
    .byte "__DDUR__"
    .asciiz "resupply"

:   .byte StratPal::Yellow
    .byte "__UULUR_"
    .asciiz "eagle rearm"

:   .byte StratPal::Yellow
    .byte "__DDDUU_"
    .asciiz "sssd delivery"

:   .byte StratPal::Yellow
    .byte "_DDLRDD_"
    .asciiz "prospecting drill"

:   .byte StratPal::Yellow
    .byte "__DUDU__"
    .asciiz "super earth flag"

:   .byte StratPal::Yellow
    .byte "DULDURDU"
    .asciiz "hellbomb"

:   .byte StratPal::Yellow
    .byte "__LRUUU_"
    .asciiz "upload data"

:   .byte StratPal::Yellow
    .byte "_UULRDD_"
    .asciiz "seismic probe"

:   .byte StratPal::Yellow
    .byte "__RRLL__"
    .asciiz "orbital illumination flare"

:   .byte StratPal::Yellow
    .byte "__RUUD__"
    .asciiz "seaf artillery"
