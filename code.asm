; asmsyntax=ca65

; Scoring:
;   - 5pt per arrow
;   - 100pt for perfect round
;   - +25pt for each round (starting at 75 for
;     round 1)
;
; Note:
; DrawSmallIcon needs to be called while the
; extended memory area is writable in extended
; attribute mode.  Also look at DrawIconExt for
; the same thing.

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
IrqWait: .res 1

Pointer1: .res 2
Pointer2: .res 2
Pointer3: .res 2
Pointer4: .res 2

ptrPpuAddress: .res 2
ptrData: .res 2
ptrTable: .res 2
ptrIRQ: .res 2
ptrNMI: .res 2

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
NextCountdown: .res 1   ; set when clear current

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

; Next IRQ state
NextIRQ: .res 1
DisableNMI: .res 1
ArrowColor: .res 1

rng: .res 1

StratsCurrent: .res 8
StratsNext: .res 8
StratsCompleted: .res 1
Round: .res 2
ClearSmallStrat: .res 1

TimerSec:   .res 1
TimerFrame: .res 1
TimerAnim:  .res 1 ; ticks up once every three frames

RoundPerfect: .res 1
NameScroll: .res 1
Score: .res 2

ScoreBonusTime: .res 1
ScoreBonusRound: .res 2

RunningScore: .res 5
RunningRound: .res 5

; Bin to Dec stuff
bdInput: .res 2
bdTmpA: .res 2
bdOutput: .res 5
.segment "OAM"

Sprites: .res 256

.segment "MAINRAM"

ArrowBufferA: .res 8
ArrowBufferB: .res 8
;ArrowBufferC: .res 23

TimerBuffer: .res 25
StratsToMake: .res 1

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
    .byte $0F, $11, $20, $28
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

SmallStratPal:
    .byte $80
    .byte $C0
    .byte $80
    .byte $C0

ArrowSize = 2
;ArrowStartAddr = $2288
ArrowStartAddr = $2285
ArrowAttrStart = $23E9

StratStartAddr = $2102
NameStartAddr = $2220

SM_STRAT_START= $218A
TimerStartSec = 10
RoundScoreDelay = 30
RoundScorePpuAddr = $2456

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
        .byte $50+i
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

RoundOverStaticStart = $2444
GameStaticText:
    .word $2057
    .asciiz "round"
    .word $20B7
    .asciiz "score"

    .word RoundOverStaticStart
    .asciiz "round bonus"
    .word RoundOverStaticStart+(64*1)
    .asciiz "time bonus"
    .word RoundOverStaticStart+(64*2)
    .asciiz "perfect bonus"
    .word RoundOverStaticStart+(64*3)
    .asciiz "total score"

    .word $0000

NameScrollOffsets:
    .byte 0
    .repeat 31, i
    .byte 256-((16-((i+1)/2))*8)+(((i+1) .mod 2)*4)
    .endrepeat

.enum IRQStates
ExtAttr
NameScroll
ArrowScroll
Menu
Timer
GameOverA
GameOverB
RoundOver
RoundOverTxt
RoundOverBottom
RoundOverPressScroll
.endenum

IrqStates:
    .word irqExtAttr     ; setup extended attributes
    .word irqNameScroll  ; center the strat name
    .word irqArrowScroll ; scroll to center arrows
    .word irqMenu        ; pause before starting game
    .word irqTimer       ; scroll for the timer bar
    .word irqGameOverA
    .word irqGameOverB
    .word irqRoundOver   ; inter-round screen
    .word irqRoundOverTxt
    .word irqRoundOverBottom
    .word irqRoundOverPressScroll

IrqLines:
    .byte 10
    .byte 130
    .byte 150
    .byte 10
    .byte 184
    .byte 130
    .byte 150
    .byte 10
    .byte 130
    .byte 150
    .byte 80
IrqStateCount = * - IrqLines

; IRQ state index in A
SetIRQ:
    ;lda NextIRQ
    tax
    asl a
    tay

    lda IrqLines, x
    sta $5203
    lda #$80
    sta $5204

    lda IrqStates+0, y
    sta ptrIRQ+0
    lda IrqStates+1, y
    sta ptrIRQ+1
    cli
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

InitGame:
    lda #$FF
    sta DisableNMI

    lda #0
    sta $2001
    sta ClearSmallStrat
    sta TimerAnim
    sta Score+0
    sta Score+1
    sta Round
    sta StratsCompleted

    lda #1
    sta StratsToMake

    lda #3
    sta TimerFrame

    lda #60
    sta AnimCountdown

    lda #100
    sta RoundPerfect

    lda #' '
    ldy #4
:
    sta RunningRound, y
    sta RunningScore, y
    dey
    bpl :-

    lda #'1'
    sta RunningRound+4
    lda #'0'
    sta RunningScore+4

    lda #.lobyte(nmiGame)
    sta ptrNMI+0
    lda #.hibyte(nmiGame)
    sta ptrNMI+1

    jsr ClearSprites

    lda #$38
    jsr FillNT0
    lda #$38
    jsr FillNT1

    ;
    ; Draw the large strat icon tiles
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

    ; Main screen
    lda #.hibyte(NameStartAddr-32)
    sta $2006
    lda #.lobyte(NameStartAddr-32)
    sta $2006
    jsr DrawTextBackground

    ; Draw ERROR on second nametable
    lda #.hibyte(NameStartAddr-32+$400)
    sta $2006
    lda #.lobyte(NameStartAddr-32+$400)
    sta $2006
    jsr DrawTextBackground

    jsr DrawSmallStrats

    ; Arrows;  they all use the same tile IDs,
    ; just different CHR banks
    lda #.lobyte(ArrowTiles)
    sta ptrTable+0
    lda #.hibyte(ArrowTiles)
    sta ptrTable+1

    .repeat 8, i
    lda #.hibyte(ArrowStartAddr+(i*3))
    sta ptrPpuAddress+1
    lda #.lobyte(ArrowStartAddr+(i*3))
    sta ptrPpuAddress+0
    lda #2
    sta IconSize
    lda #0
    jsr DrawIcon
    .endrepeat

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

    lda #%0000_0010
    sta $5104

    lda #.hibyte(StratStartAddr+$3C00)
    sta ptrPpuAddress+1
    lda #.lobyte(StratStartAddr+$3C00)
    sta ptrPpuAddress+0

    lda #1
    jsr DrawIconExt

    lda rng
    ;and #$3F
    tax
    ldy #0
:
    lda StratRngTable, x
    sta StratsCurrent, y
    inx
    txa
    and #$3F
    tax
    iny
    cpy #8
    bne :-

    lda StratsCurrent+0
    jsr LoadStrat

    lda #.lobyte(GameStaticText)
    sta ptrData+0
    lda #.hibyte(GameStaticText)
    sta ptrData+1
    jsr WriteText


    lda #%0000_0001
    sta $5104

    lda #0
    sta DisableNMI

    lda #$80
    sta $2000

    lda #0
    sta Sleeping
    jsr WaitForNMI

    ; turn off sprites
    lda #%0000_1110
    sta $2001

    lda #IRQStates::ExtAttr
    jsr SetIRQ

Frame:
    clc
    lda Round+0
    adc #1
    sta bdInput+0

    lda Round+1
    adc #0
    sta bdInput+1
    jsr BinToDec

    ldy #5
:   lda bdOutput, y
    sta RunningRound, y
    dey
    bpl :-

    lda Score+0
    sta bdInput+0
    lda Score+1
    sta bdInput+1
    jsr BinToDec

    ldy #5
:
    lda bdOutput, y
    sta RunningScore, y
    dey
    bpl :-

    clc
    ldx TimerAnim
    stx $5205 ; multiply on MMC5
    ldx #25
    stx $5206

    lda $5205
    adc #.lobyte(TimerTiles)
    sta ptrData+0

    lda $5206
    adc #.hibyte(TimerTiles)
    sta ptrData+1

    ldy #0
:
    lda (ptrData), y
    sta TimerBuffer, y
    iny
    cpy #25
    bne :-

    lda NextCountdown
    beq :+
    jmp ClearStratFrame
:

    lda ErrorCountdown
    beq :+
    jmp ErrorFrame
:

    ldx TimerFrame
    bne @timerNotYet
    ldx #3
    stx TimerFrame
    inc TimerAnim
    jmp @timerTickDone
@timerNotYet:
    dec TimerFrame
@timerTickDone:

    lda TimerAnim
    cmp #200
    bne :+
    jmp GameOver
:

    jsr ReadControllers

;    lda #BUTTON_A
;    and Controller_Pressed
;    beq :+
;    jmp NextStrat
;:

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

    lda #0
    sta RoundPerfect

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

    ;
    ; Next strat
    lda TimerAnim
    cmp #10
    bcc :+
    sec
    lda TimerAnim
    sbc #10
    sta TimerAnim
    jmp :++
:
    ; make sure the timer doesn't underflow.
    lda #0
    sta TimerAnim
:

    lda #15
    sta NextCountdown
    jsr WaitForNMI
    jmp Frame

@nextFrame:
    jsr WaitForNMI

    jmp Frame

GameOverText:
    .asciiz "game over"

GameOverStart:
    .word $2300
    .asciiz "          press  start          "
    .word $2144
    .asciiz "final score"
    .word $20E4
    .asciiz "final round"
    .word $0000

GameOver:
    jsr WaitForNMI
    sei

    lda #0
    sta $2001

    lda #.lobyte(MenuPalette)
    sta Pointer1+0
    lda #.hibyte(MenuPalette)
    sta Pointer1+1
    jsr LoadFullPalette

    lda #.lobyte(nmiGameOver)
    sta ptrNMI+0
    lda #.hibyte(nmiGameOver)
    sta ptrNMI+1

    lda #$38
    jsr FillNT0

    lda #$22
    sta $2006
    lda #$00
    sta $2006

    lda #$B9
    ldx #32
:   sta $2007
    dex
    bne :-

    lda #' '
    ldx #32
:   sta $2007
    dex
    bne :-


    lda #$BA
    ldx #32
:   sta $2007
    dex
    bne :-

    lda #.lobyte(GameOverStart)
    sta ptrData+0
    lda #.hibyte(GameOverStart)
    sta ptrData+1
    jsr WriteText

    lda #%0000_0010
    sta $5104

    lda #1
    ldx #0
    ; Just the top half of the screen
:   sta ExtAttrStart, x
    sta ExtAttrStart+$100, x
    inx
    bne :-

    lda #0
    ldx #32*3
:
    sta $2200+$3C00, x
    dex
    bpl :-

    ldy #0
    lda #1
:
    sta $22E0+$3C00, y
    iny
    cpy #96
    bne :-

    ldy #0
    lda #%0100_0001
:
    sta $20F7+$3C00, y
    iny
    cpy #5
    bne :-

    ldy #0
:
    sta $2157+$3C00, y
    iny
    cpy #5
    bne :-

    lda #%0000_0001
    sta $5104

    lda #' '
    ldy #0
:
    sta StratName, y
    iny
    cpy #31
    bne :-

    ldy #0
:
    lda GameOverText, y
    beq :+
    sta StratName, y
    iny
    jmp :-
:

    lda #$21
    sta $2006
    lda #$57
    sta $2006

    ldy #0
:   lda RunningScore, y
    sta $2007
    iny
    cpy #6
    bne :-

    lda #$20
    sta $2006
    lda #$F7
    sta $2006

    ldy #0
:   lda RunningRound, y
    sta $2007
    iny
    cpy #6
    bne :-

    jsr WaitForNMI
    lda #%0000_1100
    sta $2001

GameOverFrame:
    lda #IRQStates::GameOverA
    jsr SetIRQ

    jsr ReadControllers
    lda Controller
    and #BUTTON_START
    beq :+
    jsr WaitForNMI

    jmp InitMenu
:
    jsr WaitForNMI
    jmp GameOverFrame

NextStrat:
    ;
    ; add score for cleared strat
    lda ArrowCount
    sta $5205
    lda #5
    sta $5206

    clc
    lda $5205
    adc Score+0
    sta Score+0

    lda $5206
    adc Score+1
    sta Score+1

    ldy #0
:
    lda StratsCurrent+1, y
    sta StratsCurrent, y
    iny
    cpy #5
    bne :-

    lda StratsToMake
    beq @nomore
    dec StratsToMake

    lda rng
    ;and #$3F
    tay
    lda StratRngTable, y
    sta StratsCurrent+5
    jmp @nextFrame
@nomore:

    lda #$FF
    sta StratsCurrent+5

    lda rng
    ;and #$3F
    tay
    lda StratRngTable, y
    ldx StratsCompleted
    sta StratsNext, x

    sec
    lda #6
    sbc StratsCompleted
    sta ClearSmallStrat

    inc StratsCompleted
    lda StratsCompleted
    cmp #6
    bne :+
    jmp NextRound
:

    ; Wait for the extended attributes to get
    ; written  before updating the data.  If we
    ; don't wait we get a single frame of an icon
    ; that is either duplicated, or glitched out.
@nextFrame:
    jsr WaitForIRQ

    lda StratsCurrent+0
    jsr LoadStrat

    jsr WaitForNMI
    jmp Frame

NextRoundText:
    .asciiz "round clear"
NextRoundTextButton:
    .asciiz "press the any key"

NextRound:
    lda #.lobyte(nmiRoundOver)
    sta ptrNMI+0
    lda #.hibyte(nmiRoundOver)
    sta ptrNMI+1

    jsr WaitForNMI
    ; clear out prev scores
    .repeat 4, j
    ldx #.hibyte(RoundScorePpuAddr+(64*j))
    stx $2006
    ldx #.lobyte(RoundScorePpuAddr+(64*j))
    stx $2006

    lda #' '
    .repeat 5, i
    sta $2007
    .endrepeat
    .endrepeat

    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005

    lda #IRQStates::RoundOver
    jsr SetIRQ

    ldx #5
:
    lda StratsNext, x
    sta StratsCurrent, x
    dex
    bpl :-

    lda StratsCurrent+0
    jsr LoadStrat

    lda #0
    sta StratsCompleted
    sta ScoreBonusTime
    sta ScoreBonusRound+0
    sta ScoreBonusRound+1

    ;
    ; Time bonus
    sec
    lda #200
    sbc TimerAnim
    lsr a ; div by 2
    sta ScoreBonusTime+0
    clc
    adc Score+0
    sta Score+0
    bcc :+
    inc Score+1
:

    ;
    ; Round bonus
    lda #25
    sta $5205
    lda Round
    sta $5206

    clc
    lda $5205
    sta ScoreBonusRound+0
    adc Score+0
    sta Score+0

    lda $5206
    sta ScoreBonusRound+1
    adc Score+1
    sta Score+1

    ;
    ; Round bonus base
    clc
    lda #75
    adc Score+0
    sta Score+0
    bcc :+
    inc Score+1
:

    clc
    lda #75
    adc ScoreBonusRound+0
    sta ScoreBonusRound+0
    bcc :+
    inc ScoreBonusRound+1
:

    clc
    lda RoundPerfect
    adc Score+0
    sta Score+0
    bcc :+
    inc Score+1
:

    inc Round

    ; Round bonus bin->dec
    lda ScoreBonusRound+0
    sta bdInput+0
    lda ScoreBonusRound+1
    sta bdInput+1
    jsr BinToDec

    ldx #RoundScoreDelay
:
    jsr WaitForNMI
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005
    dex
    bne :-

    ;
    ; Write out round bonus

    lda #.hibyte(RoundScorePpuAddr+(64*0))
    sta $2006
    lda #.lobyte(RoundScorePpuAddr+(64*0))
    sta $2006

    .repeat 5, i
    lda bdOutput+i
    sta $2007
    .endrepeat
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005

    ;
    ; Time bonus bin->dec
    lda ScoreBonusTime+0
    sta bdInput+0
    lda #0
    sta bdInput+1
    jsr BinToDec

    ldx #RoundScoreDelay
:
    jsr WaitForNMI
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005
    dex
    bne :-

    ;
    ; Write out time bonus

    lda #.hibyte(RoundScorePpuAddr+(64*1))
    sta $2006
    lda #.lobyte(RoundScorePpuAddr+(64*1))
    sta $2006
    .repeat 5, i
    lda bdOutput+i
    sta $2007
    .endrepeat
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005

    ;
    ; Perfect bonus bin->dec
    lda RoundPerfect
    sta bdInput+0
    lda #0
    sta bdInput+1
    jsr BinToDec

    ldx #RoundScoreDelay
:
    jsr WaitForNMI
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005
    dex
    bne :-

    ;
    ; Write out time bonus

    lda #.hibyte(RoundScorePpuAddr+(64*2))
    sta $2006
    lda #.lobyte(RoundScorePpuAddr+(64*2))
    sta $2006
    .repeat 5, i
    lda bdOutput+i
    sta $2007
    .endrepeat
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005

    ;
    ; Total score bin->dec
    lda Score+0
    sta bdInput+0
    lda Score+1
    sta bdInput+1
    jsr BinToDec

    ldx #RoundScoreDelay
:
    jsr WaitForNMI
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005
    dex
    bne :-

    ;
    ; Write out time bonus

    lda #.hibyte(RoundScorePpuAddr+(64*3))
    sta $2006
    lda #.lobyte(RoundScorePpuAddr+(64*3))
    sta $2006
    .repeat 5, i
    lda bdOutput+i
    sta $2007
    .endrepeat

    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005

    ldx #RoundScoreDelay
:
    jsr WaitForNMI
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005
    dex
    bne :-

    lda #$25
    sta $2006
    lda #$88
    sta $2006

    ldy #0
:
    lda NextRoundTextButton, y
    beq :+
    sta $2007
    iny
    jmp :-
:
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005

NextRoundFrame:

    jsr ReadControllers
    lda Controller_Pressed
    beq :+
    jmp RoundStart
:

    jsr WaitForNMI

    lda #$81
    sta $2000

    jmp NextRoundFrame

RoundStart:
    lda #100
    sta RoundPerfect

    lda #3
    sta TimerFrame
    lda #0
    sta TimerAnim
    sta ClearSmallStrat

    jsr WaitForNMI
    lda #$81
    sta $2000

    lda #0
    sta $2005
    sta $2005

    lda #IRQStates::RoundOver
    jsr SetIRQ

    jsr DrawSmallStrats

    lda #$81
    sta $2000

    lda #0
    sta $2005
    sta $2005

    lda #.lobyte(nmiGame)
    sta ptrNMI+0
    lda #.hibyte(nmiGame)
    sta ptrNMI+1

    jsr WaitForNMI

    ; clear out "press the any key" text
    lda #$25
    sta $2006
    lda #$88
    sta $2006
    lda #' '
    .repeat 17
    sta $2007
    .endrepeat

    lda #$80
    sta $2000

    lda #0
    sta $2005
    sta $2005

    ldx Round
    inx
    stx StratsToMake

    lda #IRQStates::ExtAttr
    jsr SetIRQ
    jmp Frame

DrawSmallStrats:
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
    rts

ClearStratFrame:
    lda #$2A
    sta ArrowColor

    dec NextCountdown
    bne :+
    jsr NextStrat
:
    jsr WaitForNMI
    jmp Frame

ErrorFrame:
    dec ErrorCountdown
    beq @clearError
    lda #$16
    sta ArrowColor

    jsr WaitForNMI
    jmp Frame

@clearError:
    lda #0
    sta PressedCount
    sta ErrorIRQ

    lda #$28
    sta ArrowColor

    jsr WaitForNMI
    jmp Frame

; Set arrow color
; Index in X
; Palette in A
ArrowExtColor:
    rts

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

    lda #$28
    sta ArrowColor

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

    lda NameScrollOffsets, x
    sta NameScroll

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
    lda #0
:
    sta ArrowBufferA, x
    dex
    bpl :-

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
    ldx #0 ; index into buffer
@arrowLoop:
    ldy TmpY
    lda (Pointer3), y
    sta ArrowBufferA, x ; ID buffer
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

SmallIconAddrs:
    .word ExtAttrStart+$018A
    .word ExtAttrStart+$018E
    .word ExtAttrStart+$0192
    .word ExtAttrStart+$0196
    .word ExtAttrStart+$019A

SmallStratPpuAddrs:
    .word SM_STRAT_START+0
    .word SM_STRAT_START+4
    .word SM_STRAT_START+8
    .word SM_STRAT_START+12
    .word SM_STRAT_START+16

; Slot in A
; ID in X
DrawSmallIcon:
    asl a
    tay
    lda SmallIconAddrs+1, y
    sta Pointer1+1
    lda SmallIconAddrs+0, y
    sta Pointer1+0
    jsr FillRowPointers

    stx TmpX
    txa
    asl a
    tay

    lda StratTable+0, y
    sta ptrData+0
    lda StratTable+1, y
    sta ptrData+1

    ;
    ; Full palette -> small palette
    ldy #0
    lda (ptrData), y
    tax
    lda SmallStratPal, x
    ora TmpX

    ldy #3
@loop:
    sta (Pointer1), y
    sta (Pointer2), y
    sta (Pointer3), y
    sta (Pointer4), y
    dey
    bpl @loop
    rts

StratRngTable:
    .include "strats.rng.inc"
RngSize = (* - StratRngTable)
.out .sprintf("RngSize: %d", RngSize)

MenuBgTiles:
    .include "menu.inc"

TimerTiles:
    .include "timer.inc"

.segment "PRGINIT"
NMI:
    pha
    txa
    pha
    tya
    pha

    lda #$FF
    sta Sleeping

    lda DisableNMI
    beq :+
    jmp @nmiSkip
:

    jsr nmiJump

    lda #$80
    sta $2000

    lda #0
    sta $2005
    sta $2005

    lda #%0000_1110
    sta $2001

@nmiSkip:
    inc rng
    pla
    tay
    pla
    tax
    pla
    rti

nmiJump:
    jmp (ptrNMI)

nmiGameOver:
    lda #.lobyte(ScoresPalette)
    sta Pointer1+0
    lda #.hibyte(ScoresPalette)
    sta Pointer1+1
    jsr LoadFullPalette

    jsr NMI_DrawName
    rts

nmiGame:
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
    lda ArrowColor
    sta $2007

    .repeat 3, i
    .repeat 4, j
    lda Palettes+4+(i*4)+j
    sta $2007
    .endrepeat
    .endrepeat

    jsr NMI_DrawName
    jsr NMI_DrawTimer

    lda #$20
    sta $2006
    lda #$77
    sta $2006
    .repeat 5, i
    lda RunningRound+i
    sta $2007
    .endrepeat

    lda #$20
    sta $2006
    lda #$D7
    sta $2006
    .repeat 5, i
    lda RunningScore+i
    sta $2007
    .endrepeat

    ldx ClearSmallStrat
    bne :+
    jmp @done
:
    dex
    dex
    txa
    asl a
    tax

    lda #0
    sta ClearSmallStrat

    lda SmallStratPpuAddrs+1, x
    sta ptrPpuAddress+1
    lda SmallStratPpuAddrs+0, x
    sta ptrPpuAddress+0

    .repeat 4
    lda ptrPpuAddress+1
    sta $2006
    lda ptrPpuAddress+0
    sta $2006

    lda #$38
    .repeat 4
    sta $2007
    .endrepeat

    clc
    lda ptrPpuAddress+0
    adc #32
    sta ptrPpuAddress+0

    lda ptrPpuAddress+1
    adc #0
    sta ptrPpuAddress+1
    .endrepeat

@done:
    rts

nmiMenu:
    lda #.lobyte(MenuPalette)
    sta Pointer1+0
    lda #.hibyte(MenuPalette)
    sta Pointer1+1
    jsr LoadFullPalette
    rts

nmiRoundOver:
    lda #.lobyte(ScoresPalette)
    sta Pointer1+0
    lda #.hibyte(ScoresPalette)
    sta Pointer1+1
    jsr LoadFullPalette

    lda #.hibyte(NameStartAddr)
    sta $2006
    lda #.lobyte(NameStartAddr)
    sta $2006

    .repeat 11, i
    lda NextRoundText+i
    sta $2007
    .endrepeat

    lda #' '
    .repeat 20
    sta $2007
    .endrepeat

    rts

NMI_DrawTimer:
    lda #$23
    sta $2006
    lda #$04
    sta $2006
    .repeat 25, i
    lda TimerBuffer+i
    sta $2007
    .endrepeat
    rts

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

irqTimer:
    lda #$80
    sta $2000

    lda #4
    sta $2005
    lda #0
    sta $2005

    lda #0
    sta IrqWait

    lda #IRQStates::ExtAttr
    jsr SetIRQ
    rts

irqMenu:
    ldy #0
    lda #0
:
    sta $22E0+$3C00, y
    iny
    cpy #96
    bne :-
    rts

irqArrowScroll:
    ;lda #$FF
    ;sta NextIRQ

    lda #$80
    sta $2000
    lda IRQScroll
    sta $2005
    lda #0
    sta $2005

    lda #IRQStates::Timer
    jsr SetIRQ
    rts

irqGameOverA:
    lda #$81
    sta $2000

    lda #$A8
    sta $2005
    lda #0
    sta $2005

    lda #IRQStates::GameOverB
    jsr SetIRQ
    rts

irqGameOverB:
    lda #$80
    sta $2000

    lda #$0
    sta $2005
    lda #0
    sta $2005
    rts

irqNameScroll:

    lda #$81
    sta $2000

    lda NameScroll
    sta $2005
    lda #0
    sta $2005

    lda #IRQStates::ArrowScroll
    jsr SetIRQ
    rts

;
; Write extended attributes for large icon
; ie, write CHR bank for large strat
irqExtAttr:
    ;
    ; setup score colors
    lda #.hibyte($2057+$3C00)
    sta ptrData+1
    lda #.lobyte($2057+$3C00)
    sta ptrData+0
    lda #%1000_0001
    ldy #0
:   sta (ptrData), y
    iny
    cpy #5
    bne :-

    lda #.hibyte($2077+$3C00)
    sta ptrData+1
    lda #.lobyte($2077+$3C00)
    sta ptrData+0
    lda #%0100_0001
    ldy #0
:   sta (ptrData), y
    iny
    cpy #5
    bne :-

    lda #.hibyte($20B7+$3C00)
    sta ptrData+1
    lda #.lobyte($20B7+$3C00)
    sta ptrData+0
    lda #%1000_0001
    ldy #0
:   sta (ptrData), y
    iny
    cpy #5
    bne :-

    lda #.hibyte($20D7+$3C00)
    sta ptrData+1
    lda #.lobyte($20D7+$3C00)
    sta ptrData+0
    lda #%0100_0001
    ldy #0
:   sta (ptrData), y
    iny
    cpy #5
    bne :-

    ;
    ; Setup Main strat
    lda #.hibyte(StratStartAddr+$3C00)
    sta Pointer1+1
    lda #.lobyte(StratStartAddr+$3C00)
    sta Pointer1+0
    jsr FillRowPointers

    ;lda StratId
    lda StratsCurrent+0
    ldy #7
:
    sta (Pointer1), y
    sta (Pointer2), y
    sta (Pointer3), y
    sta (Pointer4), y
    dey
    bpl :-

    lda #.hibyte(StratStartAddr+(32*4)+$3C00)
    sta Pointer1+1
    lda #.lobyte(StratStartAddr+(32*4)+$3C00)
    sta Pointer1+0
    jsr FillRowPointers

    ;lda StratId
    lda StratsCurrent+0
    ldy #7
:
    sta (Pointer1), y
    sta (Pointer2), y
    sta (Pointer3), y
    sta (Pointer4), y
    dey
    bpl :-

    ;
    ; Update small icons
    ldy #1
    sty TmpY
@smLoop:
    ldy TmpY
    ldx StratsCurrent, y
    bmi @smClear
    dey
    tya
    jsr DrawSmallIcon

@smNext:
    inc TmpY
    lda TmpY
    cmp #6
    bne @smLoop
    jmp @smDone

@smClear:
    dey
    tya
    asl a
    tay
    lda SmallIconAddrs+0, y
    sta Pointer1+0
    lda SmallIconAddrs+1, y
    sta Pointer1+1
    jsr FillRowPointers

    lda #0
    ldy #3
:
    sta (Pointer1), y
    sta (Pointer2), y
    sta (Pointer3), y
    sta (Pointer4), y
    dey
    bpl :-
    jmp @smNext

@smDone:
    ;  clear id buffer
    lda #0
    ldx #7
:   sta ArrowBufferB, x ; Arrow IDs to write
    dex
    bpl :-

    ;
    ; Setup arrow colors
    lda PressedCount
    sta TmpX
    lda ErrorCountdown
    beq @noError
    inc TmpX

@noError:
    ;
    ; light up the arrows that have been pressed
    ldy #0
@pressedLoop:
    lda ArrowBufferA, y
    beq :++
    ldx TmpX
    beq :+
    dec TmpX
    clc
    adc #4 ; second set of arrows
:
    sta ArrowBufferB, y
:
    iny
    cpy #8
    bne @pressedLoop

    ; write arrow extended Attributes
    .repeat 8, j
    lda ArrowBufferB+j
    .repeat 2, i
    sta ArrowStartAddr+$3C00+i+(j*3)
    sta ArrowStartAddr+$3C00+32+i+(j*3)
    .endrepeat
    .endrepeat

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

    ;lda #IRQStates::Error
    lda #IRQStates::NameScroll
    jsr SetIRQ
    rts

; rewriting all the extended attribute data for
; the next round screen.
irqRoundOver:
    lda #%0100_0001
    ldy #0
:
    sta RoundScorePpuAddr-$400+$3C00+(64*0), y
    sta RoundScorePpuAddr-$400+$3C00+(64*1), y
    sta RoundScorePpuAddr-$400+$3C00+(64*2), y
    sta RoundScorePpuAddr-$400+$3C00+(64*3), y
    iny
    cpy #5
    bne :-

    lda #1
    ldy #0
:
    sta RoundOverStaticStart-$400+$3C00+(64*0), y
    sta RoundOverStaticStart-$400+$3C00+(64*1), y
    sta RoundOverStaticStart-$400+$3C00+(64*2), y
    sta RoundOverStaticStart-$400+$3C00+(64*3), y
    iny
    cpy #13
    bne :-

    ldy #0
:
    sta $2588-$400+$3C00, y
    iny
    cpy #17
    bne :-

    sta $2502-$400+$3C00
    sta $2503-$400+$3C00

    ldy #0
:
    sta $2522-$400+$3C00+(32*0), y
    sta $2522-$400+$3C00+(32*1), y
    sta $2522-$400+$3C00+(32*2), y
    iny
    cpy #8
    bne :-

    ldy #0
:
    sta $25A2-$400+$3C00+(32*0), y
    sta $25A2-$400+$3C00+(32*1), y
    sta $25A2-$400+$3C00+(32*2), y
    iny
    cpy #8
    bne :-

    ldy #0
:
    sta $2582-$400+$3C00, y
    iny
    cpy #6
    bne :-

    ; write arrow extended Attributes
    lda #0
    .repeat 8, j
    .repeat 2, i
    sta ArrowStartAddr+$3C00+i+(j*3)
    sta ArrowStartAddr+$3C00+32+i+(j*3)
    .endrepeat
    .endrepeat

    lda #IRQStates::RoundOverPressScroll
    jsr SetIRQ
    rts

irqRoundOverPressScroll:
    lda #$81
    sta $2000

    lda #4
    sta $2005
    lda #0
    sta $2005
    lda #IRQStates::RoundOverTxt
    jsr SetIRQ
    rts

irqRoundOverTxt:
    lda #$81
    sta $2000

    lda NameScrollOffsets+11
    sta $2005
    lda #0
    sta $2005
    lda #IRQStates::RoundOverBottom
    jsr SetIRQ
    rts

irqRoundOverBottom:
    lda #$81
    sta $2000

    lda #0
    sta $2005
    lda #0
    sta $2005
    lda #IRQStates::RoundOver
    jsr SetIRQ
    rts

; first address in Pointer1
; Pointer2-4 will be one PPU row later
FillRowPointers:
    clc
    lda Pointer1+0
    adc #32
    sta Pointer2+0

    lda Pointer1+1
    adc #0
    sta Pointer2+1

    clc
    lda Pointer2+0
    adc #32
    sta Pointer3+0

    lda Pointer2+1
    adc #0
    sta Pointer3+1

    clc
    lda Pointer3+0
    adc #32
    sta Pointer4+0

    lda Pointer3+1
    adc #0
    sta Pointer4+1
    rts

IrqCall:
    jmp (ptrIRQ)

IRQ:
    pha
    txa
    pha
    tya
    pha

    bit $5204
    jsr IrqCall

    pla
    tay
    pla
    tax
    pla
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
    ;jmp InitGame
    jmp InitMenu

; Wait for the exteded attribute IRQ to finish
WaitForIRQ:
    lda #$FF
    sta IrqWait
:   bit IrqWait
    bmi :-
    rts

WaitForNMI:
    lda #0
    sta Sleeping
:   bit Sleeping
    bpl :-
    rts

MMC5_Init:
    ; PRG mode 0: one 32k bank
    lda #0
    sta $5100

    ; CHR mode 1: 4k pages
    lda #1
    sta $5101

    ; Vertical mirroring
    lda #$44
    sta $5105

    ; extended attr mode
    lda #1
    sta $5104
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

ReadControllers:
    lda Controller
    sta Controller_Old

    ; Freeze input
    lda #1
    sta $4016
    lda #0
    sta $4016

    ldx #$08
@player1:
    lda $4016
    lsr A           ; Bit0 -> Carry
    rol Controller  ; Bit0 <- Carry
    dex
    bne @player1

    lda Controller_Old  ; 0001
    eor #$FF            ; 1110
    and Controller      ; 0000
    sta Controller_Pressed ; 0000
    rts

MenuText:
    .word $22C9
    .asciiz "stratagem hero"

    .word $22E0
    .repeat 32
        .byte $B9
    .endrepeat
    .byte 0

    .word $2300
    .asciiz "          press  start          "

    .word $2320
    .repeat 32
        .byte $BA
    .endrepeat
    .byte 0

    .word $0000

MenuPalette:
    .byte $0F, $28, $20, $28
    .byte $0F, $10, $20, $28
    .byte $0F, $0F, $0F, $0F
    .byte $0F, $0F, $0F, $0F

    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00

;
; for Round End and Game Over screens
ScoresPalette:
    .byte $0F, $28, $20, $28
    .byte $0F, $10, $20, $20
    .byte $0F, $0F, $0F, $0F
    .byte $0F, $0F, $0F, $0F

    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00
    .byte $0F, $10, $20, $00

InitMenu:
    lda #0
    sta $2001

    lda #$BB
    jsr FillNT0

    lda #.lobyte(nmiMenu)
    sta ptrNMI+0
    lda #.hibyte(nmiMenu)
    sta ptrNMI+1

    lda #.lobyte(MenuPalette)
    sta Pointer1+0
    lda #.hibyte(MenuPalette)
    sta Pointer1+1
    jsr LoadFullPalette

    lda #.lobyte(MenuBgTiles)
    sta ptrData+0
    lda #.hibyte(MenuBgTiles)
    sta ptrData+1
    jsr DrawFullScreen

    lda #.lobyte(MenuText)
    sta ptrData+0
    lda #.hibyte(MenuText)
    sta ptrData+1
    jsr WriteText

    lda #%0000_0010
    sta $5104
;
;   clear it all
    lda #63
    ldx #0
:   sta ExtAttrStart, x
    sta ExtAttrStart+$100, x
    sta ExtAttrStart+$200, x
    sta ExtAttrStart+$300, x
    inx
    bne :-

    lda #1
    ldx #0
:
    sta $22C0+$3C00, x
    inx
    bne :-

    lda #%0000_0001
    sta $5104

    jsr WaitForNMI

    lda #0
    sta $2001

MenuFrame:
    jsr ReadControllers
    lda Controller_Pressed
    and #BUTTON_START
    beq @nope

    lda #60
    sta TmpX
:
    lda #IRQStates::Menu
    jsr SetIRQ
    jsr WaitForNMI
    dec TmpX
    bne :-

    jmp InitGame

@nope:
    jsr WaitForNMI
    jmp MenuFrame

; Pointer to text in ptrData
; Data is an address followed by null terminated text.
; Table is terminated with an address of zero.
; Call when PPU is off.
WriteText:

@outer:
    ldy #0
    lda (ptrData), y
    sta ptrPpuAddress+0
    iny

    lda (ptrData), y
    sta ptrPpuAddress+1
    iny

    ora ptrPpuAddress+0
    beq @done

    lda ptrPpuAddress+1
    sta $2006
    lda ptrPpuAddress+0
    sta $2006

@text:
    lda (ptrData), y
    beq @next
    iny
    sta $2007
    jmp @text

@next:
    iny
    clc
    tya
    adc ptrData+0
    sta ptrData+0

    lda ptrData+1
    adc #0
    sta ptrData+1
    jmp @outer

@done:
    rts

; Pointer to data in ptrData.  Will draw a full
; screen of tiles.
DrawFullScreen:
    lda #$20
    sta $2006
    lda #$00
    sta $2006

    ldy #0
    lda (ptrData), y
    sta Pointer1+0
    iny
    lda (ptrData), y
    sta Pointer1+1

    clc
    lda ptrData+0
    adc #2
    sta ptrData+0

    lda ptrData+1
    adc #0
    sta ptrData+1

; write 3x256 tiles
    ldy #0
    ldx #3
@loopA:
    lda (ptrData), y
    sta $2007
    iny
    bne @loopA
    inc ptrData+1
    dex
    bne @loopA
    rts ; not full screen,lmao

; write 192 tiles
    ldy #0
    ldx #192
@loopB:
    lda (ptrData), y
    sta $2007
    iny
    bne @loopB
    dex
    bne @loopB
    rts

bdTable10k:
    .word 60_000
    .word 50_000
    .word 40_000
    .word 30_000
    .word 20_000
    .word 10_000
    .word 00_000

bdTable1k:
    .word 9_000
    .word 8_000
    .word 7_000
    .word 6_000
    .word 5_000
    .word 4_000
    .word 3_000
    .word 2_000
    .word 1_000
    .word 0_000

bdTable100:
    .word 900
    .word 800
    .word 700
    .word 600
    .word 500
    .word 400
    .word 300
    .word 200
    .word 100
    .word 000

bdTable10:
    .word 90
    .word 80
    .word 70
    .word 60
    .word 50
    .word 40
    .word 30
    .word 20
    .word 10
    .word 00

bdTable1:
    .word 9
    .word 8
    .word 7
    .word 6
    .word 5
    .word 4
    .word 3
    .word 2
    .word 1
    .word 0

; Input in bdInput (word)
; Output in bdOutput (5-bytes, CHR tiles)
BinToDec:
    ldy #5
    lda #0
:
    sta bdOutput, y
    dey
    bpl :-

    lda #.hibyte(bdTable10k)
    sta ptrTable+1
    lda #.lobyte(bdTable10k)
    sta ptrTable+0
    ldx #6
    jsr FindDigit
    sta bdOutput+0

    lda #.hibyte(bdTable1k)
    sta ptrTable+1
    lda #.lobyte(bdTable1k)
    sta ptrTable+0
    ldx #9
    jsr FindDigit
    sta bdOutput+1

    lda #.hibyte(bdTable100)
    sta ptrTable+1
    lda #.lobyte(bdTable100)
    sta ptrTable+0
    ldx #9
    jsr FindDigit
    sta bdOutput+2

    lda #.hibyte(bdTable10)
    sta ptrTable+1
    lda #.lobyte(bdTable10)
    sta ptrTable+0
    ldx #9
    jsr FindDigit
    sta bdOutput+3

    lda #.hibyte(bdTable1)
    sta ptrTable+1
    lda #.lobyte(bdTable1)
    sta ptrTable+0
    ldx #9
    jsr FindDigit
    sta bdOutput+4

    ldy #0
:
    lda bdOutput, y
    cmp #'0'
    bne :+
    lda #' '
    sta bdOutput, y
    iny
    cpy #4
    bne :-
:
    rts

FindDigit:
    ldy #0
@loop2:
    lda (ptrTable), y
    sta bdTmpA+0
    iny
    lda (ptrTable), y
    sta bdTmpA+1
    iny
    jsr bdCompare
    bcs :+
    dex
    jmp @loop2
    sta bdOutput+1
:
    dey
    dey

    sec
    lda bdInput+0
    sbc (ptrTable), y
    sta bdInput+0
    iny

    lda bdInput+1
    sbc (ptrTable), y
    sta bdInput+1

    txa
    ora #'0'
    rts

bdCompare:
    lda bdInput+1
    cmp bdTmpA+1
    bne :+
    lda bdInput+0
    cmp bdTmpA+0
:
    rts
