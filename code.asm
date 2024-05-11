; asmsyntax=ca65

.include "nes2header.inc"
nes2mapper 5
nes2prg 32 * 1024  ; 32k PRG
nes2chr 32 * 8 * 1024  ; 32k CHR
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
PressedCount: .res 1
ArrowCount: .res 1
IconSize: .res 1
StratId: .res 1
StratPalette: .res 1
StratName: .res 31
ErrorCountdown: .res 1

AnimCounter: .res 1
AnimCountdown: .res 1
AttrBuffer: .res 6

Controller: .res 1
Controller_Old: .res 1
Controller_Pressed: .res 1
ErrorIRQ: .res 1

UpdateName: .res 1

DrawName: .res 1
IRQScroll: .res 1

.segment "OAM"

Sprites: .res 256

.segment "MAINRAM"

ArrowBufferA: .res 23
ArrowBufferB: .res 23
;ArrowBufferC: .res 23

.segment "PAGE00"

.enum StratPal
Blue
Red
Yellow
Green
.endenum

.include "strats.inc"

ArrowStarts:
    .byte 0
    ; ____D___
    .byte 4
    ; ___DD___
    .byte 3
    ; ___DDD__
    .byte 3
    ; __DDDD__
    .byte 2
    ; __DDDDD_
    .byte 2
    ; _DDDDDD_
    .byte 1
    ; _DDDDDDD
    .byte 1
    ; DDDDDDDD
    .byte 0

ArrowAttrOffsets:
    .byte 0, 0
    .byte 1, 0
    .byte 1, 2
    .byte 2, 0

    .byte 3, 0
    .byte 4, 0
    .byte 4, 5
    .byte 5, 0

;ArrowAttrOffsets:
;    .byte 1, 0
;    .byte 2, 0
;    .byte 2, 3
;    .byte 3, 0
;
;    .byte 4, 0
;    .byte 5, 0
;    .byte 5, 6
;    .byte 6, 0

ArrowAttrMasks:
    ; BR, BL, TR, TL
    .byte %0000_1111, %0000_0000
    .byte %0000_0011, %0000_0000
    .byte %0000_1100, %0000_0011
    .byte %0000_1100, %0000_0000

    .byte %0000_1111, %0000_0000
    .byte %0000_0011, %0000_0000
    .byte %0000_1100, %0000_0011
    .byte %0000_1100, %0000_0000

Palettes:
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $28, $20
    .byte $0F, $11, $20, $28
    .byte $0F, $19, $20, $16

    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00

StratPalettes:
    ; blue
    .byte $0F, $11, $20, $28
    ; red
    .byte $0F, $16, $20, $28
    ; yellow
    .byte $0F, $28, $20, $28
    ; green
    .byte $0F, $19, $20, $28

ArrowSize = 2
;ArrowStartAddr = $2288
ArrowStartAddr = $2285
ArrowAttrStart = $23E9

StratStartAddr = $2102
NameStartAddr = $2221

SM_STRAT_START= $218A

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
        .byte $38
        ;.byte $3C
    .endrepeat

    ; up
:   .repeat 4, i
        .byte i+(4*0)+$80
    .endrepeat

    ; down
:   .repeat 4, i
        .byte i+(4*1)+$80
    .endrepeat

    ; left
:   .repeat 4, i
        .byte i+(4*2)+$80
    .endrepeat

    ; right
:   .repeat 4, i
        .byte i+(4*3)+$80
    .endrepeat

.enum Strats
eagle500k = 0
hellbomb
orbital_precision
.endenum

; the documentation lies.  .pushcharmap and .popcharmap throw errors
;.pushcharmap

;.popcharmap
;.repeat $FF, i
;    .charmap i, i
;.endrepeat

; So we can just use the DrawIcon routine
Strat_LgIconAddr:
    .word Strat_LgIcon

; All large stratagem icons fill a full
; 1k CHR bank, so they'll all have the
; same CHR ids.
Strat_LgIcon:
    .repeat 64, i
        .byte i
    .endrepeat

DrawSmall_16:
    lda #$21
    sta $2006
    lda #$8C
    sta $2006

    ldy #$EC
.repeat 2
    sty $2007
    iny
.endrepeat

    lda #$21
    sta $2006
    lda #$AC
    sta $2006

.repeat 2
    sty $2007
    iny
.endrepeat
    rts

DrawSmall_24:
    lda ptrPpuAddress+1
    sta $2006
    lda ptrPpuAddress+0
    sta $2006

    ldy #$80
.repeat 3
    sty $2007
    iny
.endrepeat

    clc
    lda ptrPpuAddress+0
    adc #32
    sta ptrPpuAddress+0
    bcc :+
    inc ptrPpuAddress+1
:

    lda ptrPpuAddress+1
    sta $2006
    lda ptrPpuAddress+0
    sta $2006

.repeat 3
    sty $2007
    iny
.endrepeat

    clc
    lda ptrPpuAddress+0
    adc #32
    sta ptrPpuAddress+0
    bcc :+
    inc ptrPpuAddress+1
:

    lda ptrPpuAddress+1
    sta $2006
    lda ptrPpuAddress+0
    sta $2006

.repeat 3
    sty $2007
    iny
.endrepeat
    rts

DrawSmall_32:
    lda ptrPpuAddress+1
    sta $2006
    lda ptrPpuAddress+0
    sta $2006

    ldy #$40
.repeat 4
    sty $2007
    iny
.endrepeat

.repeat 3
    clc
    lda ptrPpuAddress+0
    adc #32
    sta ptrPpuAddress+0
    bcc :+
    inc ptrPpuAddress+1
:

    lda ptrPpuAddress+1
    sta $2006
    lda ptrPpuAddress+0
    sta $2006

.repeat 4
    sty $2007
    iny
.endrepeat
.endrepeat
    rts

DebugText:
    .asciiz "henlo"

InitGame:
    lda #.lobyte(Palettes)
    sta Pointer1+0
    lda #.hibyte(Palettes)
    sta Pointer1+1
    jsr LoadFullPalette

    jsr ClearSprites

    lda #$38
    jsr FillNT0
    lda #$39
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

    ;lda #.hibyte(StratStartAddr+$400)
    ;sta ptrPpuAddress+1
    ;lda #.lobyte(StratStartAddr+$400)
    ;sta ptrPpuAddress+0
    ;lda #.lobyte(Strat_LgIconAddr)
    ;sta ptrTable+0
    ;lda #.hibyte(Strat_LgIconAddr)
    ;sta ptrTable+1
    ;lda #8
    ;sta IconSize
    ;lda #0
    ;jsr DrawIcon

    ; Main screen
    lda #.hibyte(NameStartAddr-1-32)
    sta $2006
    lda #.lobyte(NameStartAddr-1-32)
    sta $2006
    jsr DrawTextBackground

    ; Draw ERROR on second nametable
    lda #.hibyte(NameStartAddr-1-32+$400)
    sta $2006
    lda #.lobyte(NameStartAddr-1-32+$400)
    sta $2006
    jsr DrawTextBackground

    ;lda #$26
    ;sta $2006
    ;lda #$2E
    ;sta $2006

    ;lda ErrorText+0
    ;sta $2007
    ;lda ErrorText+1
    ;sta $2007
    ;lda ErrorText+2
    ;sta $2007
    ;lda ErrorText+3
    ;sta $2007
    ;lda ErrorText+4
    ;sta $2007

    lda #0
    jsr LoadStrat

    ;jsr DrawSmall_16
    ldy #0

    lda #.hibyte(SM_STRAT_START)
    sta ptrPpuAddress+1
    lda #.lobyte(SM_STRAT_START)
    sta ptrPpuAddress+0
    jsr DrawSmall_32

    lda #.hibyte(SM_STRAT_START+(4*1))
    sta ptrPpuAddress+1
    lda #.lobyte(SM_STRAT_START+(4*1))
    sta ptrPpuAddress+0
    jsr DrawSmall_32

    lda #.hibyte(SM_STRAT_START+(4*2))
    sta ptrPpuAddress+1
    lda #.lobyte(SM_STRAT_START+(4*2))
    sta ptrPpuAddress+0
    jsr DrawSmall_32

    lda #.hibyte(SM_STRAT_START+(4*3))
    sta ptrPpuAddress+1
    lda #.lobyte(SM_STRAT_START+(4*3))
    sta ptrPpuAddress+0
    jsr DrawSmall_32

    lda #.hibyte(SM_STRAT_START+(4*4))
    sta ptrPpuAddress+1
    lda #.lobyte(SM_STRAT_START+(4*4))
    sta ptrPpuAddress+0
    jsr DrawSmall_32

    lda #$20
    sta $2006
    lda #$26
    sta $2006
    ldx #0
:   lda DebugText, x
    beq :+
    sta $2007
    inx
    jmp :-
:

    ; extended attr
ExtAttrStart = $5C00
    lda #%0000_0010
    sta $5104

;
;   clear it all
    lda #%0000_0000
    ldx #0
:   sta ExtAttrStart, x
    sta ExtAttrStart+$100, x
    sta ExtAttrStart+$200, x
    sta ExtAttrStart+$300, x
    inx
    bne :-


    lda #%0100_0001 ; "inverted" text
    ldx #0
:   sta ExtAttrStart, x
    inx
    bne :-

    lda #%0000_0001
    sta $5104

    ;
    ; small icons
    lda #$80 | 01
    ldx #0
:   sta ExtAttrStart+$018A, x
    sta ExtAttrStart+$01AA, x
    sta ExtAttrStart+$01CA, x
    sta ExtAttrStart+$01EA, x
    inx
    cpx #4
    bne :-

    lda #$C0 | 11
    ldx #0
:   sta ExtAttrStart+$018E, x
    sta ExtAttrStart+$01AE, x
    sta ExtAttrStart+$01CE, x
    sta ExtAttrStart+$01EE, x
    inx
    cpx #4
    bne :-

    lda #$C0 | 30
    ldx #0
:   sta ExtAttrStart+$0192, x
    sta ExtAttrStart+$01B2, x
    sta ExtAttrStart+$01D2, x
    sta ExtAttrStart+$01F2, x
    inx
    cpx #4
    bne :-

    lda #$80 | 59
    ldx #0
:   sta ExtAttrStart+$0196, x
    sta ExtAttrStart+$01B6, x
    sta ExtAttrStart+$01D6, x
    sta ExtAttrStart+$01F6, x
    inx
    cpx #4
    bne :-

    lda #.hibyte(StratStartAddr+$3C00)
    sta ptrPpuAddress+1
    lda #.lobyte(StratStartAddr+$3C00)
    sta ptrPpuAddress+0

    lda #1
    jsr DrawIconExt

    lda #$88
    sta $2000

    lda #%0001_1110
    sta $2001

    lda #60
    sta AnimCountdown

Frame:
    lda #150
    sta $5203
    lda #$80
    sta $5204
    cli

    lda ErrorCountdown
    beq :+
    jmp ErrorFrame
:

    jsr ReadControllers

    lda #BUTTON_A
    and Controller_Pressed
    beq :+
    jmp NextStrat
:

    lda #BUTTON_B
    and Controller_Pressed
    beq :+
    jmp PrevStrat
:

    ldx PressedCount
    lda StratBuffer, x
    sta TmpX

    lda #BUTTON_UP  ; 1
    and Controller_Pressed
    beq :+
    lda #ARROW_UP
    jmp @compare
:

    lda #BUTTON_DOWN  ; 1
    and Controller_Pressed
    beq :+
    lda #ARROW_DOWN
    jmp @compare
:

    lda #BUTTON_LEFT  ; 1
    and Controller_Pressed
    beq :+
    lda #ARROW_LEFT
    jmp @compare
:

    lda #BUTTON_RIGHT  ; 1
    and Controller_Pressed
    beq :+
    lda #ARROW_RIGHT
    jmp @compare
:

    ; nothing pressed
    jmp @nextFrame

@compare:
    cmp TmpX
    beq @goodPress
;@badPress:

    lda #60
    sta ErrorCountdown

    jmp @nextFrame
@goodPress:
    ldx ArrowCount
    lda ArrowStarts, x
    clc
    adc PressedCount
    asl a
    tax

    ldy ArrowAttrOffsets, x ;index into buffer
    lda #%0101_0101
    and ArrowAttrMasks, x
    ora AttrBuffer, y ; doesn't really do anything right now.
    sta AttrBuffer, y

    inx
    iny
    lda #%0101_0101
    and ArrowAttrMasks, x
    ora AttrBuffer, y ; doesn't really do anything right now.
    sta AttrBuffer, y

    inc PressedCount
    lda PressedCount
    cmp ArrowCount
    bne @nextFrame
    ; TODO: done with current?
    jsr WaitForNMI
    jmp NextStrat

@nextFrame:
    jsr WaitForNMI

    jmp Frame

PrevStrat:
    dec StratId
    lda StratId
    cmp #$FF
    bne :+
    lda #STRAT_COUNT-1
    sta StratId
    jmp :+

NextStrat:
    inc StratId
:   lda StratId
    cmp #STRAT_COUNT
    bcc :+
    lda #0
    sta StratId
:
    jsr LoadStrat

    jmp Frame

ErrorFrame:
    lda #0
    ldx #0
:
    sta AttrBuffer, x
    inx
    cpx #.sizeof(AttrBuffer)
    bne :-

    dec ErrorCountdown
    beq @clearError

    ldx ArrowCount
    lda ArrowStarts, x
    clc
    adc PressedCount
    asl a
    tax

:
    ldy ArrowAttrOffsets, x ;index into buffer
    lda #%1010_1010
    and ArrowAttrMasks, x
    ora AttrBuffer, y ; doesn't really do anything right now.
    sta AttrBuffer, y

    inx
    iny
    lda #%1010_1010
    and ArrowAttrMasks, x
    ora AttrBuffer, y ; doesn't really do anything right now.
    sta AttrBuffer, y

    dex
    dex
    dex
    bpl :-

    lda #1
    sta ErrorIRQ

    lda #130
    sta $5203
    lda #$80
    sta $5204
    cli

    jsr WaitForNMI
    jmp Frame

@clearError:
    lda #0
    sta PressedCount

    jsr WaitForNMI
    jmp Frame

AnimateArrows:
    ;dec AnimCountdown
    ;bne @noAnim
    ;lda #60
    ;sta AnimCountdown

    ldy #0
    lda #0
:
    sta AttrBuffer, y
    iny
    cpy #.sizeof(AttrBuffer)
    bne :-

    lda AnimCounter
    asl a
    tax ; offset

    ldy ArrowAttrOffsets, x ;index into buffer

    lda #%0101_0101
    and ArrowAttrMasks, x
    ora AttrBuffer, y ; doesn't really do anything right now.
    sta AttrBuffer, y

    inx
    iny
    lda #%0101_0101
    and ArrowAttrMasks, x
    ora AttrBuffer, y ; doesn't really do anything right now.
    sta AttrBuffer, y

    ldx AnimCounter
    inx
    cpx #8
    bne :+
    ldx #0
:
    stx AnimCounter
;@noAnim:
    rts

; Strat ID in A
LoadStrat:
    sta StratId
    asl a
    tay
    lda StratTable+0, y
    sta Pointer3+0
    lda StratTable+1, y
    sta Pointer3+1

    lda #0
    sta PressedCount
    ldy #.sizeof(AttrBuffer)-1
:
    sta AttrBuffer, y
    dey
    bpl :-

    ldy #0
    lda (Pointer3), y
    sta StratPalette
    iny


; Load arrow code into RAM
    ldx #0
    stx ArrowCount
@loop:
    lda (Pointer3), y
    ;cpx #ARROW_NONE
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

    lda #' '
    jmp :++
:
    sta StratName, x
    inx
:   cpx #31
    bne :--

    ; draw all the arrows

    ; clear buffer
    ldx #.sizeof(ArrowBufferA)-1
    lda #$38
:
    sta ArrowBufferA, x
    sta ArrowBufferB, x
    ;sta ArrowBufferC, x
    dex
    bpl :-

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

    lda #1 ; offset into data
    sta TmpY
    ;lda #0
    ;sta TmpX ; index into buffer
    ldx #0
@arrowLoop:
    ldy TmpY
    lda (Pointer3), y
    ;jsr DrawIcon
    asl a
    tay

    lda ArrowTiles, y
    sta ptrData+0
    lda ArrowTiles+1, y
    sta ptrData+1
    ldy #0

    ; top row
    lda (ptrData), y
    sta ArrowBufferA, x
    iny
    lda (ptrData), y
    sta ArrowBufferA+1, x

    ; bottom row
    iny
    lda (ptrData), y
    sta ArrowBufferB, x
    iny
    lda (ptrData), y
    sta ArrowBufferB+1, x

    inx
    inx
    inx

    inc TmpY
    lda TmpY
    cmp #9
    bne @arrowLoop
    rts

DrawTextBackground:
    lda #$B9
    ldy #32
:   sta $2007
    dey
    bne :-

    lda #$B7
    ldy #32
:   sta $2007
    dey
    bne :-

    lda #$BA
    ldy #32
:   sta $2007
    dey
    bne :-

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

DrawIconExt:
    sta TmpY ; strat value to store

    lda IconSize
    sta TmpX
@row:
    clc
    adc #32
    sta ptrPpuAddress+0
    bcc :+
    inc ptrPpuAddress+1
:

    ldx IconSize
    ldy #0
@column:
    lda TmpY
    sta (ptrPpuAddress), y
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
    txa
    pha
    tya
    pha

    lda #$FF
    sta Sleeping

    ;lda #.lobyte(Sprites)
    ;sta $2003
    ;lda #.hibyte(Sprites)
    ;sta $4014

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

    lda ErrorCountdown
    bne :+
    lda StratPalettes+3, x
    sta $2007
    jmp :++
:
    lda #$16
    sta $2007
:

    lda #.hibyte(ArrowAttrStart)
    sta $2006
    lda #.lobyte(ArrowAttrStart)
    sta $2006

    ldx #0
:
    lda AttrBuffer, x
    sta $2007
    inx
    cpx #.sizeof(AttrBuffer)
    bne :-

    jsr NMI_DrawName
    jsr NMI_DrawArrows

    ldx StratId
    ;inx
    stx $5123

    lda ArrowCount
    and #$01
    bne :+
    lda #0 ; even
    jmp :++
:
    ;lda #8 ; odd
    lda #16 ; odd
:
    sta IRQScroll

    lda #$88
    sta $2000

    lda #0
    sta $2005
    sta $2005

@nmiDone:

    lda #%0001_1110
    sta $2001

;;

    pla
    tay
    pla
    tax
    pla
    rti

NMI_DrawName:
    lda #.hibyte(NameStartAddr)
    sta $2006
    lda #.lobyte(NameStartAddr)
    sta $2006

.repeat 31, i
    lda StratName+i
    sta $2007
.endrepeat
    rts

NMI_DrawArrows:
    lda #.hibyte(ArrowStartAddr)
    sta $2006
    lda #.lobyte(ArrowStartAddr)
    sta $2006

.repeat .sizeof(ArrowBufferA), i
    lda ArrowBufferA+i
    sta $2007
.endrepeat

    lda #.hibyte(ArrowStartAddr+32)
    sta $2006
    lda #.lobyte(ArrowStartAddr+32)
    sta $2006

.repeat .sizeof(ArrowBufferB), i
    lda ArrowBufferB+i
    sta $2007
.endrepeat
    rts

IRQ:
    bit $5204

    lda ErrorIRQ
    beq @noError

    lda #0
    sta ErrorIRQ

    lda #$89
    sta $2000

    lda #0
    sta $2005
    sta $2005

    lda #150
    sta $5203
    lda #$80
    sta $5204
    rti

@noError:
    lda #$88
    sta $2000
    lda IRQScroll
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
    lda #1
    sta $5101

    ; Vertical mirroring
    lda #$44
    sta $5105

    ; extended attr mode
    lda #1
    sta $5104

    ; initial CHR banks
    ldy #0
    sty $5120
    iny
    sty $5121

    ldy #64
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

ClearExt:

ReadControllers:
    lda Controller
    sta Controller_Old

    ; Freeze input
    lda #1
    sta $4016
    lda #0
    sta $4016
    ;sta Controller

    ldx #$08
@player1:
    lda $4016
    lsr A           ; Bit0 -> Carry
    rol Controller  ; Bit0 <- Carry
    dex
    bne @player1

    ;lda Controller
    ;eor Controller_Old

    lda Controller_Old  ; 0001
    eor #$FF            ; 1110
    and Controller      ; 0000
    sta Controller_Pressed ; 0000
    rts

; Was a button pressed this frame?
ButtonPressed:
    sta TmpX
    and Controller
    sta TmpY

    lda Controller_Old
    and TmpX

    cmp TmpY
    bne btnPress_stb

    ; no button change
    rts

btnPress_stb:
    ; button released
    lda TmpY
    bne btnPress_stc
    rts

btnPress_stc:
    ; button pressed
    lda #1
    rts
