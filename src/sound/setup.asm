INCLUDE "ramvars/sound.inc"
INCLUDE "sound_registers.inc"

Section "AUDIO CONFIG", ROM0
SETUP_AUDIO::
    ld a, %01110111
    ldh [SOUND_VOL_CTRL], a
    ld a, %11111111
    ldh [SOUND_PAN_CTRL], a
    ld a, %10000000
    ldh [SOUND_ON_OFF], a

    ld a, $04
    ldh [SOUND_CH1_VOL_ENV], a
    ldh [SOUND_CH2_VOL_ENV], a
    ld a, $F4
    ldh [SOUND_CH1_VOL_ENV], a
    ld a, $F1
    ldh [SOUND_CH2_VOL_ENV], a

    ld a, $B0
    ldh [SOUND_CH1_LEN_DUTY], a
    ldh [SOUND_CH2_LEN_DUTY], a

    ret

LOAD_HEADER::
    ; assumes header pointer is in hl

    ; load main data start pointer
    ld a, [hli]
    ld [CH1_DATA_START], a
    ld a, [hli]
    ld [CH1_DATA_START+1], a

    ; channel 1 always starts off at the pointer
    ld a, $00
    ld [CH1_OFFSET], a
    
    ; ch2
    ld a, [hli]
    ld [CH2_OFFSET], a

    ; ch3
    ld a, [hli]
    ld [CH3_OFFSET], a

    ; ch4
    ld a, [hl]
    ld [CH4_OFFSET], a

    ld a, $80
    ld [CH1_LEN], a
    ld [CH2_LEN], a
    ld [CH3_LEN], a
    ld [CH4_LEN], a

    ret
