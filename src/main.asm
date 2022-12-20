; MAIN.ASM
; main code

include "sound_registers.inc"

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
  ld c, 17
  call LOAD_TILES

  ; ld hl, TEST_MAP
  ; ld c, 17
  ; call LOAD_MAP

  call DEAD_BEEF

  ld a, %11100100
  call SET_BACKGROUND_PALLETTE

  ld a, %10010011
  call SET_LDC_CFG

.loop
  call WAIT_VBLANK
  call NEXT_NOTE
  jr .loop
