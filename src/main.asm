; MAIN.ASM
; main code

INCLUDE "sound_registers.inc"
INCLUDE "ramvars/sound.inc"

; --- Program Start ---
SECTION "Program Start",ROM0[$0150]
START::
  di                         ; disable interrupts
  ld sp, $FFFE               ; set the stack to $FFFE

.setup
  ; setup audio
  ld hl, LENGTH_TEST
  call SETUP_AUDIO
  call LOAD_HEADER

  ; setup graphics
  call WAIT_VBLANK

  ; turn off LCD
  ld a, $00
  call SET_LDC_CFG

  call CLEAR_OAM
  call CLEAR_MAP

  ld hl, HEX_TILES
  ld c, 21
  call LOAD_TILES

  ; load CH character offset into a
  ld a, (HEX_TILES.CH - HEX_TILES) >> 4

  ld de, (4 * 32 + 1) ; row 1, col 1
  call DISPLAY_TILE ; Ch1 display
  
  ld de, (6 * 32 + 1) ; row 3, col 1
  call DISPLAY_TILE ; Ch2 display
  
  ld a, $01
  ld de, (4 * 32 + 2) ; row 1, col 2
  call DISPLAY_NIBBLE

  ld a, $02
  ld de, (6 * 32 + 2) ; row 1, col 2
  call DISPLAY_NIBBLE

  ld a, %11100100
  call SET_BACKGROUND_PALLETTE

  ld a, %10010011
  call SET_LDC_CFG

.loop
  call WAIT_VBLANK
  
  ; audio subroutines
  call NEXT_NOTE

  ; display subroutines
  ; CH1
  ld de, (4 * 32 + 4)
  ld a, [CH1_OFFSET]
  call DISPLAY_CHAR
  
  ld de, (4 * 32 + 8)
  ld hl, CH1_LEN
  call DISPLAY_LEN
  
  ; CH2
  ld de, (6 * 32 + 4)
  ld a, [CH2_OFFSET]
  call DISPLAY_CHAR
  
  ld de, (6 * 32 + 8)
  ld hl, CH2_LEN
  call DISPLAY_LEN

  ld de, (2 * 32 + 4)
  ld a, [CH1_DATA_START+1]
  call DISPLAY_CHAR
  inc e
  ld a, [CH1_DATA_START]
  call DISPLAY_CHAR

  jr .loop

DISPLAY_LEN:
  ; displays the length stored in hl at the coordinate de
  ; output is the form XX -> YY
  ; where XX is the raw value, and YY is the computed length

  ld a, [hl]
  and $3F
  ld c, a

  call DISPLAY_CHAR

  inc e ; second nibble
  inc e ; needs spacing around the arrow to look nice

  ; load arrow character offset into a
  ld a, (HEX_TILES.arrow - HEX_TILES) >> 4
  call DISPLAY_TILE
  
  inc e ; arrow
  inc e ; space
  
  ld a, $40
  sub c
  call DISPLAY_CHAR

  ret

