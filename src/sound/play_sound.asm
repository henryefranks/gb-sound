INCLUDE "ramvars/sound.inc"
INCLUDE "sound_registers.inc"

Section "Audio Playback", ROM0
NEXT_NOTE::
    ldh a, [SOUND_ON_OFF]
    bit 0, a ; check for channel 1 playing
    call z, NEXT_NOTE_CH1

    ldh a, [SOUND_ON_OFF]
    bit 1, a ; check for channel 2 playing
    call z, NEXT_NOTE_CH2

    ret

NEXT_NOTE_CH1:
    ld c, $00
    jr PLAY_NEXT_NOTE
    
NEXT_NOTE_CH2:
    ld c, $01
    jr PLAY_NEXT_NOTE
    
PLAY_NEXT_NOTE:
    ld b, $00
    push bc

    call GET_NEXT_NOTE

    bit 7, a        ; if bit 7 is set, we have length data
    jr nz, .set_length
    jr .play_note

.set_length:
    and a, $BF      ; mask a to unset bit 6 (gives 50% DC)

    pop bc          ; channel select
    ld hl, SOUND_LEN_BASE
    add hl, bc
    ld [hl], a      ; store length in variable

    ret

.play_note:
    ; play a note
    ; assumes the note code (1 byte) is stored in a
    ; assumes that the channel select is on stack

    call GET_NOTE_DATA  ; frequency is now in (de)

    ; load duration
    pop bc  ; pop channel select off stack

    ; get location of sound length variable
    ld hl, SOUND_LEN_BASE    ; table lookup
    add hl, bc               ; channel select
    ld a, [hl]               ; length is now in a

    ; get register data from table
    ld hl, TABLE_REG_SOUND_BASE
    add hl, bc  ; channel select
    ld l, [hl]  ; copy the data from the table to hl, offset from $FF00
    ld h, $FF
    ; hl now points to NRx0

    inc hl      ; NRx1 register

    ld [hl], a  ; load length to NRx1
    inc hl      ; NRx2 (Volume/Envelope)

    inc hl      ; NRx3 (freq low)
    ld [hl], e

    inc hl      ; NRx4 (freq hi + trigger)
    ld [hl], d

    ret

GET_NEXT_NOTE:
    ; use data stored in c to grab current offset
    ; assumes b == 0
    ld hl, SOUND_OFFSET_BASE

    add hl, bc
    ld c, [hl]
    inc [hl]

    ; store current pointer base in hl
    ld a, [CH1_DATA_START]
    ld l, a
    ld a, [CH1_DATA_START+1]
    ld h, a

    ; add offset to base pointer
    add hl, bc
    ld a, [hl] ; this is our new note data

    ret

GET_NOTE_DATA:
    ; get the address of the note with value in a
    ; returns the two bytes in de

    ld hl, note_table
    ld b, $00
    ld c, a
    
    ; multiply by 2 to account for 2-byte entry size
    sla c   ; shift left
    rl b    ; used to carry from c -> b

    add hl, bc ; get address
    ld e, [hl]
    inc hl
    ld a, [hl]
    or $C0 ; enable play and length flags
    ld d, a

    ret

Section "REGISTER TABLES", rom0
TABLE_REG_SOUND_BASE::
    db $10, $15, $1A, $19
