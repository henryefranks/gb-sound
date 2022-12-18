; MAIN.ASM
; main code

include "sound_registers.inc"

; --- Program Start ---
SECTION "Program Start",ROM0[$0150]
START::
  di                         ; disable interrupts
  ld sp, $FFFE               ; set the stack to $FFFE

.setup
  ld hl, DEMO_SONG
  call LOAD_HEADER

.loop
  call WAIT_VBLANK
  call NEXT_NOTE_CH1
  jr .loop

WAIT_VBLANK:
  ldh a,[$FF44]		  ; get current scanline
  cp $91			      ; check if v-blank
  jr nz, WAIT_VBLANK
  ret
