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

LOOP::
.up
  ld hl, SOUNDROM + SOUND_HEADER_SIZE
.call_next
  call WAIT_FOR_CH3_FREE
  call SOUND_3_HL

  ld a, l
  sub 24
  jp z, .down
  jp .call_next

.down
  ld hl, SOUNDROM + SOUND_HEADER_SIZE
  ld a, [SOUNDROM]
  ld b, a
  ld a, [SOUNDROM+1]
  ld c, a
  add hl, bc
.call_prev
  call WAIT_FOR_CH3_FREE
  call SOUND_3_HL

  ld a, l
  sub 6
  ld l, a

  jp z, .up
  jp .call_prev

