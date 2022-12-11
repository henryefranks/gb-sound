; SOUND.ASM
; audio subroutines

INCLUDE "sound.inc"
INCLUDE "play_sound.inc"
INCLUDE "data/demo_music.inc"
INCLUDE "sound_registers.inc"

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
  ldh [SOUND_CH3_DAC_EN], a

  ld hl, WAVERAM

  ld de, SOUND_CH3_WAVERAM_START

  REPT $10
    ld a, [hli]
    ld [de], a
    inc e
  ENDR

  ; re-enable CH3
  ld a, $80
  ldh [SOUND_CH3_DAC_EN], a

  ret

SOUND_3_INIT::
  ; set volume to 100%
  ld a, %00100000
  ldh [SOUND_CH3_VOL], a

  call LOAD_WAVEFORM_RAM

  ; initialise our pointer to the start of the data
  ld hl, CH3_PTR
  ld a, [_DEMO_DATA_START + 5]
  ld [hli], a
  ld a, [_DEMO_DATA_START + 4]
  ld [hl], a

  ret


PLAY_CH3_SOUND::
  ; check if the channel's free (ie not currently playing)
  ; if not, return
  ldh a, [SOUND_ON_OFF]
  and $04 ; bit 3
  ret nz ; if channel is playing (bit is nonzero), return
  ; the channel isn't playing, so let's play the next sound in the db
  ld a, 2
  call PROCESS_SOUND_OBJ
  ret

Section "Waveform RAM", ROM0[WAVERAM]
  dl $FFEDCA98, $8ABCDEFF, $001234567, $76532100

