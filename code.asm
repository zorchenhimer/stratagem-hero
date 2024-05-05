; asmsyntax=ca65

.include "nes2header.inc"
nes2mapper 5
nes2prg 32 * 1024  ; 32k PRG
nes2chr 32 * 1024  ; 32k CHR
nes2chrram 0
nes2wram 0
nes2mirror 'V'
nes2tv 'N'
nes2end

.feature leading_dot_in_identifiers
.feature underline_in_numbers

; Button Constants
BUTTON_A        = 1 << 7
BUTTON_B        = 1 << 6
BUTTON_SELECT   = 1 << 5
BUTTON_START    = 1 << 4
BUTTON_UP       = 1 << 3
BUTTON_DOWN     = 1 << 2
BUTTON_LEFT     = 1 << 1
BUTTON_RIGHT    = 1 << 0

.segment "VECTORS"
    .word NMI
    .word RESET
    .word IRQ

.segment "ZEROPAGE"
Sleeping: .res 1

Pointer1: .res 2
Pointer2: .res 2
Pointer3: .res 2
Pointer4: .res 2

ptrPpuAddress: .res 2
ptrData: .res 2
ptrTable: .res 2

TmpX: .res 1
TmpY: .res 1
TmpZ: .res 1

StratBuffer: .res 8
ArrowCount: .res 1
IconSize: .res 1
StratId: .res 1
StratPalette: .res 1
StratName: .res 31

.segment "OAM"

Sprites: .res 256

.segment "MAINRAM"

.segment "PAGE00"

.enum StratPal
Blue
Red
Yellow
Green
.endenum

StratPalettes:
    ; blue
    .byte $0F, $11, $20, $28
    ; red
    .byte $0F, $15, $20, $28
    ; yellow
    .byte $0F, $27, $20, $28
    ; green
    .byte $0F, $19, $20, $28

ArrowSize = 2
;ArrowStartAddr = $2288
ArrowStartAddr = $2285

StratStartAddr = $2104
NameStartAddr = $2221

.enum Arrow
Empty = 0
Up
Down
Left
Right
.endenum

ArrowTiles:
    .word :+
    .word :++
    .word :+++
    .word :++++
    .word :+++++

    ; empty
:   .repeat 4, i
        ;.byte $40
        .byte $37
    .endrepeat

    ; up
:   .repeat 4, i
        .byte i+(4*0)
    .endrepeat

    ; down
:   .repeat 4, i
        .byte i+(4*1)
    .endrepeat

    ; left
:   .repeat 4, i
        .byte i+(4*2)
    .endrepeat

    ; right
:   .repeat 4, i
        .byte i+(4*3)
    .endrepeat

Palettes:
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00

    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00

.enum Strats
eagle500k = 0
hellbomb
orbital_precision
.endenum

; the documentation lies.  .pushcharmap and .popcharmap throw errors
;.pushcharmap
;.charmap ' ', 0
;.charmap 'u', 1
;.charmap 'd', 2
;.charmap 'l', 3
;.charmap 'r', 4

StratTable:
.include "strats.i"

;StratCodes:
;    .word :+
;    .word :++
;    .word :+++
;
;:   .byte " urdddd "
;:   .byte "duldurdu"
;:   .byte "   rru  "

;.popcharmap
.repeat $FF, i
    .charmap i, i
.endrepeat

; So we can just use the DrawIcon routine
Strat_LgIconAddr:
    .word Strat_LgIcon

; All large stratagem icons fill a full
; 1k CHR bank, so they'll all have the
; same CHR ids.
Strat_LgIcon:
    .repeat 64, i
        .byte i+(64*0)+$40
    .endrepeat

InitGame:
    lda #.lobyte(Palettes)
    sta Pointer1+0
    lda #.hibyte(Palettes)
    sta Pointer1+1
    jsr LoadFullPalette

    jsr ClearSprites

    lda #$40
    jsr FillNT0
    lda #$40
    jsr FillNT1

    lda #.hibyte(StratStartAddr)
    sta ptrPpuAddress+1
    lda #.lobyte(StratStartAddr)
    sta ptrPpuAddress+0
    lda #.lobyte(Strat_LgIconAddr)
    sta ptrTable+0
    lda #.hibyte(Strat_LgIconAddr)
    sta ptrTable+1
    lda #8
    sta IconSize
    lda #0
    jsr DrawIcon

    lda #$22
    sta $2006
    lda #$2F
    sta $2006
    lda #$80
    sta $2007
    sta $2007

    ;lda #2
    lda #1
    jsr LoadStrat

    lda #$88
    sta $2000

    lda #%0001_1110
    sta $2001

Frame:
    lda #150
    sta $5203
    lda #$80
    sta $5204
    cli

    jsr WaitForNMI
    jmp Frame

; Strat ID in A
LoadStrat:
    sta StratId
    asl a
    tay
    lda StratTable+0, y
    sta Pointer3+0
    lda StratTable+1, y
    sta Pointer3+1

    ldy #0
    lda (Pointer3), y
    sta StratPalette
    iny

; Load arrow code into RAM
    ldx #0
    stx ArrowCount
@loop:
    lda (Pointer3), y
    beq @next

    inc ArrowCount
    sta StratBuffer, x
    inx
@next:
    iny
    cpy #9 ; not 8, because palette ID is before this
    bne @loop

    cpx #8
    beq @bufferDone

    lda #0
:   sta StratBuffer, x
    inx
    cpx #8
    bne :-

@bufferDone:

    ; load the text into ram
    ldx #0
@nameloop:
    lda (Pointer3), y
    beq @namedone
    iny
    sta StratName, x
    inx
    jmp @nameloop
@namedone:

    lda #$37
    cpx #32
    beq :+
:
    sta StratName, x
    inx
    cpx #31
    bne :-

    lda #.hibyte(NameStartAddr-1-32)
    sta $2006
    lda #.lobyte(NameStartAddr-1-32)
    sta $2006

    lda #$39
    ldy #32
:   sta $2007
    dey
    bne :-

    lda #$37
    sta $2007

    ldy #0
@namedraw:
    lda StratName, y
    sta $2007
    iny
    cpy #31
    bne @namedraw

    lda #$3A
    ldy #32
:   sta $2007
    dey
    bne :-

    ; draw all the arrows
    ; ArrowStartAddr -> Pointer4
    lda #.hibyte(ArrowStartAddr)
    sta Pointer4+1
    lda #.lobyte(ArrowStartAddr)
    sta Pointer4+0

    ;
    ; ArrowTiles -> ptrTable
    lda #.lobyte(ArrowTiles)
    sta ptrTable+0
    lda #.hibyte(ArrowTiles)
    sta ptrTable+1
    lda #ArrowSize
    sta IconSize

    lda #1 ; arrow number
    sta TmpY
@arrowLoop:
    lda Pointer4+0
    sta ptrPpuAddress+0
    lda Pointer4+1
    sta ptrPpuAddress+1

    ldy TmpY
    lda (Pointer3), y
    jsr DrawIcon

    clc
    lda Pointer4+0
    ;adc #ArrowSize
    ;adc #4
    adc #3
    sta Pointer4+0
    bcc :+
    inc Pointer4+1
:
    inc TmpY
    lda TmpY
    cmp #9
    bne @arrowLoop
    rts

DrawIcon:
    asl a
    tay
    lda (ptrTable), y
    sta ptrData+0
    iny
    lda (ptrTable), y
    sta ptrData+1

    lda IconSize
    sta TmpX
    ldy #0
@row:
    lda ptrPpuAddress+1
    sta $2006
    lda ptrPpuAddress+0
    sta $2006

    clc
    adc #32
    sta ptrPpuAddress+0
    bcc :+
    inc ptrPpuAddress+1
:

    ldx IconSize
@column:
    lda (ptrData), y
    sta $2007
    iny
    dex
    bne @column
    dec TmpX
    bne @row

    rts

LoadFullPalette:
    lda #$3F
    sta $2006
    lda #$00
    sta $2006

    ldy #0
:
    lda (Pointer1), y
    sta $2007
    iny
    cpy #32
    bne :-
    rts

.segment "PRGINIT"
NMI:
    pha
    lda #$FF
    sta Sleeping

    lda #.lobyte(Sprites)
    sta $2003
    lda #.hibyte(Sprites)
    sta $4014

    lda StratPalette
    asl a
    asl a
    tax
    lda #$3F
    sta $2006
    lda #$00
    sta $2006

    lda StratPalettes+0, x
    sta $2007
    lda StratPalettes+1, x
    sta $2007
    lda StratPalettes+2, x
    sta $2007
    lda StratPalettes+3, x
    sta $2007

    lda #$88
    sta $2000

    lda #%0001_1110
    sta $2001

    lda #0
    sta $2005
    sta $2005

    pla
    rti

IRQ:
    bit $5204

    lda ArrowCount
    and #$01
    bne :+
    lda #8
    jmp :++
:
    lda #0
:
    sta $2005
    lda #0
    sta $2005
    rti

RESET:
    sei         ; Disable IRQs
    cld         ; Disable decimal mode

    ldx #$40
    stx $4017   ; Disable APU frame IRQ

    ldx #$FF
    txs         ; Setup new stack

    inx         ; Now X = 0

    stx $2000   ; disable NMI
    stx $2001   ; disable rendering
    stx $4010   ; disable DMC IRQs

:   ; First wait for VBlank to make sure PPU is ready.
    bit $2002   ; test this bit with ACC
    bpl :- ; Branch on result plus

:   ; Clear RAM
    lda #$00
    sta $0000, x
    sta $0100, x
    sta $0200, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x

    inx
    bne :-  ; loop if != 0

:   ; Second wait for vblank.  PPU is ready after this
    bit $2002
    bpl :-

    lda #$88
    sta $2000

    jsr MMC5_Init
    ;jsr MMC5_ChrReverse
    ;jmp Frame
    jmp InitGame

WaitForNMI:
:   bit Sleeping
    bpl :-
    lda #0
    sta Sleeping
    rts

MMC5_Init:
    ; PRG mode 0: one 32k bank
    lda #0
    sta $5100

    ; CHR mode 3: 1k pages
    lda #3
    sta $5101

    ; Vertical mirroring
    lda #$44
    sta $5105

    ; initial CHR banks
    ldy #0
    sty $5120
    iny
    sty $5121
    iny
    sty $5122
    iny
    sty $5123
    iny
    sty $5124
    iny
    sty $5125
    iny
    sty $5126
    iny
    sty $5127

    rts

MMC5_ChrReverse:
    ; initial CHR banks
    ldy #7
    sty $5120
    dey
    sty $5121
    dey
    sty $5122
    dey
    sty $5123
    dey
    sty $5124
    dey
    sty $5125
    dey
    sty $5126
    dey
    sty $5127
    rts

ClearSprites:
    ldy #0
    lda #$F0
:
    sta Sprites, y
    iny
    bne :-
    rts

FillNT0:
    pha
    lda #$20
    sta $2006
    lda #$00
    sta $2006
    jmp FillNT

FillNT1:
    pha
    lda #$24
    sta $2006
    lda #$00
    sta $2006
    jmp FillNT

FillNT:

    pla
    ldy #30
:
    ldx #32
:
    sta $2007
    dex
    bne :-
    dey
    bne :--

    rts
