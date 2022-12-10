; SOUND.ASM
; audio subroutines

INCLUDE "sound.inc"

SECTION "Sound",ROM0
INIT_SOUND::
  ld a, %01110111
  ldh [$FF24], a
  ld a, %11111111
  ldh [$FF25], a
  ld a, %10000000
  ldh [$FF26], a

  ret

LOAD_WAVEFORM_RAM::
  ; make sure CH3 is disabled before we load data
  ld a, $00
  ldh [$FF1A], a

  ld hl, WAVERAM

  ld de, $FF30

  REPT $10
    ld a, [hli]
    ld [de], a
    inc e
  ENDR

  ; re-enable CH3
  ld a, $80
  ldh [$FF1A], a

  ret

SOUND_1::
  ld a, %00010110
  ldh [$FF10], a

  ld a, %10000000
  ldh [$FF11], a

  ld a, %01110000
  ldh [$FF12], a

  ld a, %00000000
  ldh [$FF13], a

  ld a, %11000011
  ldh [$FF14], a

  ret

SOUND_2::
  ld a, %10000000
  ldh [$FF16], a

  ld a, %01110000
  ldh [$FF17], a

  ld a, %00000000
  ldh [$FF18], a

  ld a, %11000011
  ldh [$FF19], a

  ret

SOUND_3::
  ld a, %10000000
  ldh [$FF1A], a

  ld a, %00000000
  ldh [$FF1B], a

  ld a, %00100000
  ldh [$FF1C], a

  ld a, %00000000
  ldh [$FF1D], a

  ld a, %11000110
  ldh [$FF1E], a

  ret

SOUND_3_INIT::
  ld a, %10000000
  ldh [$FF1A], a
  ld a, %00100000
  ldh [$FF1C], a

  call LOAD_WAVEFORM_RAM
  
  ret

WAIT_FOR_CH3_FREE::
  ldh a, [$FF26]
  and $04
  jp nz, WAIT_FOR_CH3_FREE
  ret

SOUND_3_HL::
  ; take address in (hl) and play sound
  ; corresponding to data stored in hl and hl+1
  ;
  ; leaves (hl) pointing to next table entry
  ; i.e. hl+3

  ld a, [hli]
  ldh [$FF1B], a
  ld a, [hli]
  ldh [$FF1D], a
  ld a, [hli]
  or $C0
  ldh [$FF1E], a
  ret
  

Section "Waveform RAM", ROM0[WAVERAM]
  ;dl $FFEDCA98, $8ABCDEFF, $001234567, $76532100
  dl $FFFFFFF8, $9CFFFFFF, $00000136, $76431000

