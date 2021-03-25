; Test game for the NES
;
; Author: hoh

  .inesprg 1    ; Defines the number of 16kb PRG banks
  .ineschr 1    ; Defines the number of 8kb CHR banks
  .inesmap 0    ; Defines the NES mapper
  .inesmir 1    ; Defines VRAM mirroring of banks

  .rsset $0000
pointerBackgroundLowByte  .rs 1
pointerBackgroundHighByte .rs 1

keroTile1Y = $0300
keroTile2Y = $0304
keroTile3Y = $0308
keroTile4Y = $030C

keroTile1CHR = $0301
keroTile2CHR = $0305
keroTile3CHR = $0309
keroTile4CHR = $030D

keroTile5Y = $0310
keroTile6Y = $0314
keroTile7Y = $0318
keroTile8Y = $031C

keroTile5CHR = $0311
keroTile6CHR = $0315
keroTile7CHR = $0319
keroTile8CHR = $031D

keroTile8ATR = $031E

keroTile9Y = $0320
keroTileAY = $0324

keroTile9ATR = $0322
keroTileAATR = $0326

keroTile1X = $0303
keroTile2X = $0307
keroTile3X = $030B
keroTile4X = $030F

keroTile5X = $0313
keroTile6X = $0317
keroTile7X = $031B
keroTile8X = $031F

keroTile9X = $0323
keroTileAX = $0327

flowerTile1Y = $0328
flowerTile2Y = $032C
flowerTile3Y = $0330
flowerTile4Y = $0334

flowerTile1CHR = $0329
flowerTile2CHR = $032D
flowerTile3CHR = $0331
flowerTile4CHR = $0335

flowerTile1ATR = $032A
flowerTile2ATR = $032E
flowerTile3ATR = $0332
flowerTile4ATR = $0336

flowerTile1X = $032B
flowerTile2X = $032F
flowerTile3X = $0333
flowerTile4X = $0337

eyeTileY = $0338
eyeTileATR = $033A

fire1Y = $0340
fire2Y = $0344
fire3Y = $0348
fire4Y = $034C
fire5Y = $0350
fire6Y = $0354

fire1CHR = $0341
fire2CHR = $0345
fire3CHR = $0349
fire4CHR = $034D
fire5CHR = $0351
fire6CHR = $0355

fire1ATR = $0342
fire2ATR = $0346
fire3ATR = $034A
fire4ATR = $034E
fire5ATR = $0352
fire6ATR = $0356

fire1X = $0343
fire2X = $0347
fire3X = $034B
fire4X = $034F
fire5X = $0353
fire6X = $0357

Clock = $1000
AnimationTimer = $1001



  .bank 0
  .org $C000

RESET:
  JSR LoadBackground
  JSR LoadPalettes
  JSR LoadAttributes
  JSR LoadSprites

  LDA #%10001000   ; Enable NMI, sprites and background on table 0
  STA $2000
  LDA #%00011110   ; Enable sprites, enable backgrounds
  STA $2001
  LDA #$00         ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005
  LDA #%00000000
  STA Clock
  STA AnimationTimer

  lda #$01
  sta $4015
  lda #$00
  sta $4001
  lda #$40
  sta $4017

InfiniteLoop:
  JMP InfiniteLoop

LoadBackground:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #LOW(background)
  STA pointerBackgroundLowByte
  LDA #HIGH(background)
  STA pointerBackgroundHighByte

  LDX #$00
  LDY #$00
.Loop:
  LDA [pointerBackgroundLowByte], y
  STA $2007

  INY
  CPY #$00
  BNE .Loop

  INC pointerBackgroundHighByte
  INX
  CPX #$04
  BNE .Loop
  RTS

LoadPalettes:
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
.Loop:
  LDA palettes, x
  STA $2007
  INX
  CPX #$20
  BNE .Loop
  RTS

LoadAttributes:
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
.Loop:
  LDA attributes, x
  STA $2007
  INX
  CPX #$40
  BNE .Loop
  RTS

LoadSprites:
  LDX #$00
.Loop:
  LDA sprites, x
  STA $0300, x
  INX
  CPX #$58
  BNE .Loop
  RTS

ReadPlayerOneControls:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016

ReadA:
  LDA $4016       ; Player 1 - A
  AND #%00000001
  BEQ EndReadA
  LDA #$40
  STA AnimationTimer
EndReadA:

  LDA $4016       ; Player 1 - B
  LDA $4016       ; Player 1 - Select
  LDA $4016       ; Player 1 - Start

ReadUp:
  LDA $4016       ; Player 1 - Up
  AND #%00000001
  BEQ EndReadUp

  LDA keroTile1Y
  SEC
  SBC #$02
  STA keroTile1Y
  STA keroTile5Y

  LDA keroTile2Y
  SEC
  SBC #$02
  STA keroTile2Y
  STA keroTile6Y
  STA keroTile9Y
  STA keroTileAY

  LDA keroTile3Y
  SEC
  SBC #$02
  STA keroTile3Y
  STA keroTile7Y

  LDA keroTile4Y
  SEC
  SBC #$02
  STA keroTile4Y
  STA keroTile8Y

EndReadUp:

ReadDown:
  LDA $4016       ; Player 1 - Down
  AND #%00000001
  BEQ EndReadDown

  LDA keroTile1Y
  CLC
  ADC #$02
  STA keroTile1Y
  STA keroTile5Y

  LDA keroTile2Y
  CLC
  ADC #$02
  STA keroTile2Y
  STA keroTile6Y
  STA keroTile9Y
  STA keroTileAY

  LDA keroTile3Y
  CLC
  ADC #$02
  STA keroTile3Y
  STA keroTile7Y

  LDA keroTile4Y
  CLC
  ADC #$02
  STA keroTile4Y
  STA keroTile8Y
EndReadDown:

ReadLeft:
  LDA $4016       ; Player 1 - Left
  AND #%00000001
  BEQ EndReadLeft

  LDA keroTile1X
  SEC
  SBC #$02
  STA keroTile1X
  STA keroTile2X
  STA keroTile3X
  STA keroTile4X

  LDA keroTile5X
  SEC
  SBC #$02
  STA keroTile5X
  STA keroTile6X
  STA keroTile7X
  STA keroTile8X

  LDA keroTile9X
  SEC
  SBC #$02
  STA keroTile9X

  LDA keroTileAX
  SEC
  SBC #$02
  STA keroTileAX

EndReadLeft:

ReadRight:
  LDA $4016       ; Player 1 - Right
  AND #%00000001
  BEQ EndReadRight

  LDA keroTile1X
  CLC
  ADC #$02
  STA keroTile1X
  STA keroTile2X
  STA keroTile3X
  STA keroTile4X

  LDA keroTile5X
  CLC
  ADC #$02
  STA keroTile5X
  STA keroTile6X
  STA keroTile7X
  STA keroTile8X

  LDA keroTile9X
  CLC
  ADC #$02
  STA keroTile9X

  LDA keroTileAX
  CLC
  ADC #$02
  STA keroTileAX

EndReadRight:

  RTS

MoveFlower:
  LDA flowerTile1Y
  CLC
  ADC #$01
  STA flowerTile1Y
  STA flowerTile2Y

  LDA flowerTile3Y
  CLC
  ADC #$01
  STA flowerTile3Y
  STA flowerTile4Y

  AND #%11111111
  BNE EndMoveFlower

  LDA flowerTile1X
  CLC
  ADC #$80
  STA flowerTile1X
  STA flowerTile3X

  LDA flowerTile2X
  CLC
  ADC #$80
  STA flowerTile2X
  STA flowerTile4X

EndMoveFlower:
  RTS

FlipFlower:
  LDA #$01
  STA flowerTile1CHR
  LDA #$02
  STA flowerTile2CHR
  LDA #$03
  STA flowerTile3CHR
  LDA #$04
  STA flowerTile4CHR

  LDA #$01
  STA flowerTile1ATR
  STA flowerTile2ATR
  STA flowerTile3ATR
  STA flowerTile4ATR

  LDA Clock
  AND #%00010000
  BNE EndFlipFlower

  LDA #$02
  STA flowerTile1CHR
  LDA #$01
  STA flowerTile2CHR
  LDA #$04
  STA flowerTile3CHR
  LDA #$03
  STA flowerTile4CHR

  LDA #$41
  STA flowerTile1ATR
  STA flowerTile2ATR
  STA flowerTile3ATR
  STA flowerTile4ATR

EndFlipFlower:
  RTS

Blink:
  LDA #$2F
  STA eyeTileY
  LDA #$00
  STA eyeTileATR
  LDA Clock
  AND #%11111000
  BNE EndBlink

  LDA #$3A
  STA eyeTileY
  LDA #$20
  STA eyeTileATR

EndBlink:
  RTS

WingFlap:
  LDA Clock
  AND #%00011111
  BNE EndWingFlap

  LDA keroTile9Y
  CLC
  ADC #$01
  STA keroTile9Y
  STA keroTileAY

  LDA Clock
  AND #%00111111
  BNE EndWingFlap

  LDA keroTile9Y
  SEC
  SBC #$02
  STA keroTile9Y
  STA keroTileAY

EndWingFlap:
  RTS

LowC:
  pha
  lda #$84
  sta $4000
  lda #$AA
  sta $4002
  lda #$09
  sta $4003
  pla
  rts

Collision:
  LDA keroTile1Y
  ADC #$16
  CMP flowerTile1Y
  BCC EndCollision

  SBC #$16
  CMP flowerTile1Y
  BCS EndCollision

  LDA keroTile1X
  ADC #$8
  CMP flowerTile1X
  BCC EndCollision

  SBC #$10
  CMP flowerTile1X
  BCS EndCollision

  JSR LowC

EndCollision:
  RTS

FireClear:
  LDA #$22
  STA fire1ATR
  STA fire2ATR
  STA fire3ATR
  STA fire4ATR
  STA fire5ATR
  STA fire6ATR
  LDA #$00
  STA fire1Y
  STA fire2Y
  STA fire3Y
  STA fire4Y
  STA fire5Y
  STA fire6Y
  STA fire1X
  STA fire2X
  STA fire3X
  STA fire4X
  STA fire5X
  STA fire6X
  STA AnimationTimer
  STA keroTile9ATR

  LDA #$06
  STA keroTile1CHR
  STA keroTile5CHR
  LDA #$07
  STA keroTile2CHR
  STA keroTile6CHR
  LDA #$08
  STA keroTile3CHR
  STA keroTile7CHR
  LDA #$09
  STA keroTile4CHR
  STA keroTile8CHR

  LDA keroTile7X
  STA keroTile8X
  STA keroTile5X

  LDA keroTile2X
  STA keroTile4X
  STA keroTile1X
  LDA keroTile8Y
  STA keroTile4Y

  LDA keroTile2Y
  STA keroTile9Y
  STA keroTileAY
  LDA keroTile4X
  SBC #$07
  STA keroTile9X
  ADC #$17
  STA keroTileAX

  LDA #$40
  STA keroTile8ATR
  STA keroTileAATR
  RTS

AttackSetup:
  LDA AnimationTimer
  CMP #$3E
  BNE EndAttackSetup
  LDA #$12
  STA keroTile1CHR
  LDA #$13
  STA keroTile2CHR
  LDA #$14
  STA keroTile3CHR
  LDA #$15
  STA keroTile4CHR
  LDA #$16
  STA keroTile5CHR
  LDA #$17
  STA keroTile6CHR
  LDA #$18
  STA keroTile7CHR
  LDA #$19
  STA keroTile8CHR
  LDA keroTile7X
  SBC #$03
  STA keroTile8X

  LDA keroTile2Y
  STA keroTile4Y
  LDA keroTile2X
  SBC #$07
  STA keroTile4X

  LDA #$00
  STA keroTile9X
  STA keroTileAX
  STA keroTile9Y
  STA keroTileAY
  LDA #$20
  STA keroTile9ATR
  STA keroTileAATR
EndAttackSetup:
  JMP BackAttackSetup

FireFlip:
  LDA AnimationTimer
  CMP #$28
  BEQ EndFireFlip
  CMP #$18
  BEQ EndFireFlip
  CMP #$08
  BEQ EndFireFlip
  JMP BackFireFlip
EndFireFlip:
  LDA #$82
  STA fire1ATR
  STA fire2ATR
  STA fire3ATR
  STA fire4ATR
  STA fire5ATR
  STA fire6ATR
  LDA #$0f
  STA fire1CHR
  LDA #$10
  STA fire2CHR
  LDA #$11
  STA fire3CHR
  LDA #$0c
  STA fire4CHR
  LDA #$0d
  STA fire5CHR
  LDA #$0e
  STA fire6CHR
  JMP BackFireFlip

FireStart:
  LDA AnimationTimer
  CMP #$30
  BEQ EndFireStart
  CMP #$20
  BEQ EndFireStart
  CMP #$20
  BEQ EndFireStart
  JMP BackFireStart
EndFireStart:
  LDA #$02
  STA fire1ATR
  STA fire2ATR
  STA fire3ATR
  STA fire4ATR
  STA fire5ATR
  STA fire6ATR
  LDA keroTile1Y
  STA fire1Y
  STA fire2Y
  STA fire3Y
  ADC #$07
  STA fire4Y
  STA fire5Y
  STA fire6Y
  LDA keroTile1X
  ADC #$15
  STA fire1X
  STA fire4X
  ADC #$08
  STA fire2X
  STA fire5X
  ADC #$08
  STA fire3X
  STA fire6X
  LDA #$0c
  STA fire1CHR
  LDA #$0d
  STA fire2CHR
  LDA #$0e
  STA fire3CHR
  LDA #$0f
  STA fire4CHR
  LDA #$10
  STA fire5CHR
  LDA #$11
  STA fire6CHR

  LDA keroTile2X
  ADC #$02
  STA keroTile1X
  ADC #$08
  STA keroTile5X
  LDA #$1A
  STA keroTile2CHR
  LDA #$1B
  STA keroTile3CHR
  LDA #$1C
  STA keroTile6CHR
  LDA #$1D
  STA keroTile7CHR
  LDA #$00
  STA keroTile8ATR
  LDA keroTile7X
  SBC #$01
  STA keroTile8X
  LDA keroTile2X
  SBC #$08
  STA keroTile4X
  RTS

AnimateA:
  JMP AttackSetup
BackAttackSetup:
  JMP FireStart
BackFireStart:
  JMP FireFlip
BackFireFlip:
  CMP #$02
  BCS EndAnimateA
  JSR FireClear
EndAnimateA:
  RTS

NMI:
  LDA #$00
  STA $2003
  LDA #$03
  STA $4014

  LDA Clock
  CLC
  ADC #$01
  STA Clock

  JSR MoveFlower
  JSR FlipFlower
  JSR Blink
  JSR WingFlap
  JSR Collision

  LDA AnimationTimer
  BEQ After
  SBC #$01
  STA AnimationTimer
  JSR AnimateA
  LDA AnimationTimer
  BNE EndMain
After:

  JSR ReadPlayerOneControls

EndMain:

  RTI

  .bank 1
  .org $E000

background:
  .include "graphics/background.asm"

palettes:
  .include "graphics/palettes.asm"

attributes:
  .include "graphics/attributes.asm"

sprites:
  .include "graphics/sprites.asm"

  .org $FFFA
  .dw NMI
  .dw RESET
  .dw 0

  .bank 2
  .org $0000
  .incbin "bin.chr"
