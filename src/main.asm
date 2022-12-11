; MAIN.ASM
; main code

include "sound.inc"

; --- Program Start ---
SECTION "Program Start",ROM0[$0150]
START::
  di                         ; disable interrupts
  ld sp, $FFFE               ; set the stack to $FFFE

  call INIT_SOUND
  call SOUND_3_INIT

.loop
  call WAIT_VBLANK
  call PLAY_CH3_SOUND
  jr .loop

WAIT_VBLANK:
  ldh a,[$FF44]		  ; get current scanline
  cp $91			      ; check if v-blank
  jr nz, WAIT_VBLANK
  ret
