INCLUDE "ramvars/sound.inc"
INCLUDE "sound_registers.inc"

Section "CH1 Sound Functions", ROM0
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

    call SETUP_CH1 ; hack for now

    ret

SETUP_CH1: ; DELETEME
    ld a, %01110111
    ldh [SOUND_VOL_CTRL], a
    ld a, %11111111
    ldh [SOUND_PAN_CTRL], a
    ld a, %10000000
    ldh [SOUND_ON_OFF], a

    ld a, $00
    ldh [SOUND_CH1_VOL_ENV], a
    ld a, $F2
    ldh [SOUND_CH1_VOL_ENV], a

    ld a, $B0
    ldh [SOUND_CH1_LEN_DUTY], a

    ret

NEXT_NOTE_CH1::
    call CHECK_PLAYING_CH1
    ret nz

    call GET_NEXT_NOTE_CH1

    bit 7, a        ; if bit 7 is set, we have length data
    jp nz, .set_length
    
    call PLAY_NOTE_CH1

    ret

.set_length:
    and $BF      ; mask a to unset bit 6 (gives 50% DC)
    ld [CH1_LEN], a

    ret

CHECK_PLAYING_CH1:
    ldh a, [SOUND_ON_OFF]
    and $01 ; bit 0
    ret

CHECK_PLAYING_CH2:
    ldh a, [SOUND_ON_OFF]
    and $02 ; bit 0
    ret

GET_NEXT_NOTE_CH1:
    ; get the next note queued for channel 1,
    ; and increment pointer
    ld a, [CH1_DATA_START]
    ld l, a
    ld a, [CH1_DATA_START+1]
    ld h, a
    
    ld a, [CH1_OFFSET]
    
    ; add offset to hl
    ld c, a
    ld b, $00
    add hl, bc
    
    ; increment and save offset
    inc a
    ld [CH1_OFFSET], a

    ld a, [hl]      ; this is our new note data

    ret

PLAY_NOTE_CH1:
    ; play a note
    ; assumes the note code (1 byte) is stored in a

    ld hl, note_table
    ld b, $00
    ld c, a
    
    ; multiply by 2 to account for 2-byte entry size
    sla c   ; shift left
    rl b    ; used to carry from c -> b

    add hl, bc ; get address

    ; load duration
    ld a, [CH1_LEN]
    ldh [SOUND_CH1_LEN_DUTY], a

    ; load in frequency
    ld a, [hli]
    ldh [SOUND_CH1_WAVELEN_L], a
    ld a, [hl]
    or $C0 ; enable play and length flags
    ldh [SOUND_CH1_WAVELEN_H_CTRL], a

    ret
    