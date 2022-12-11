INCLUDE "play_sound.inc"
INCLUDE "sound_registers.inc"

SECTION "PLAY_SOUND", ROM0
PROCESS_SOUND_OBJ::
    ; Process a single sound object from our data.
    ;
    ; We take a pointer to our sound data in hl and which channel the data
    ; is intended for in a, and use the data structure found there to perform
    ; some sound operation. For full details of the sound feature set, see
    ; the description in demo_music.asm.

    push af ; keep a copy of our offset a for later

    ; load the correct pointer into hl
    ld hl, CH1_PTR

    ld c, a     ; load our current poitner offset from a into c
    ld b, $00   ; pad b with zeroes so bc == 0a
    sla c       ; shift bc left to multiply offset by 2
    rl b        ; this step accounts for carry (see JUMP_TABLE)
    add hl, bc  ; add our offset to our address
    ; hl now points to one of CH1_PTR, CH2_PTR, CH3_PTR, or CH4_PTR
    ; depending on the value of a when the function is called

    push hl     ; keep a copy of this for later
    ; we'll need to know where the pointer is when we want to edit its value

    ld d, [hl]  ; load in our current command
    inc hl      ; hl currently points to our pointer,
    ld e, [hl]  ; so we need to grab that data and store it

    push de     ; push pointer to the stack as JUMP_TABLE alters de

    ld a, [de]  ; load our opcode into a

    ; == JUMP TABLE ==
    ; We now jump to the location corresponding to our opcode stored in a
    call JUMP_TABLE
    dw .cmd_noop, .cmd_play, .cmd_goto

.cmd_noop: ; FIXME: NEEDS TO PLAY NO SOUND
    ; remove 3 values off the stack (af and de pushed earlier)
    ld hl, sp + 6 ; 4 = 2 words x 3 entries
    ld sp, hl
    ret
    
.cmd_play:
    pop hl  ; grab pointer off the stack
    pop de  ; grab the location of our current channel pointer off the stack
    pop bc  ; grab channel select off the stack
    ; c will have some garbage flag data, we don't worry about this

    push de ; this is horrible, but we keep a copy
            ; of the channel pointer for later

    ; at this point, we have:
    ; * a  - our sound channel
    ; * hl - pointer to the start of our data
    call PLAY_SOUND

    ; we now need to increment our data pointer to the next entry

    pop hl  ; pointer to our data pointer, as stored before PLAY_SOUND

    ; we now copy the data in [hl] and [hl+1] to de
    ld d, [hl]  ; grab the upper byte, store in d
    inc hl      ; point to the next byte
    ld e, [hl]  ; grab the lower byte, store in e

    push hl     ; now save hl for writing back later

    ; now add our offset
    ld hl, 5    ; current janky way: make hl + de = 5 + addr
    add hl, de
    ld d, h     ; now we copy hl to de
    ld e, l     ; ...in two parts
    
    ; finally, run the inverse of above to de data back
    pop hl

    ld [hl], e
    dec hl
    ld [hl], d

    ret
    
.cmd_goto:
    ; we need to copy our new data pointer over the old
    pop hl  ; grab pointer off the stack

    ; copy our new address (2 words) to de
    inc hl
    ld d, [hl]
    inc hl
    ld e, [hl]

    pop hl ; grab the channel pointer
    
    ld [hl], e  ; now copy de to [hl] and [hl+1]
    inc hl
    ld [hl], d

    pop hl  ; grab channel select off the stack
    ; the channel number isn't used here as we're operating solely on
    ; the pointer, but we need it off the stack before we return

    ret

PLAY_SOUND::
    ; takes pointer to sound data in hl and plays the corresponding sound
    ; according to the channel select in a
    ;
    ; arguments:
    ; > registers
    ;   * b   (u8) - offset 
    ;   * hl (r16) - pointer to the start of our data struct (opcode)
    ;
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ;
    ; we have a bunch of structures in our sound ROM that look like:
    ;
    ; {
    ;   u8 opcode (0x01)  <-- [hl] points here!
    ;   u8 length
    ;   u16 wavelen
    ; }
    ;
    ; where wavelen is the 11b value corresponding to the expression
    ; | freq = 65536 / (2048 - wavelen)
    ; |      = $10000 / ($800 - wavelen)
    ; (note we store these in the 11 lsb of the 16b value)
    ;
    ; this subroutine copies the length data directly to the length
    ; register (NR31), which sets a timeout on our sound, while our full
    ; 16b value in the next register is copied to NR33 and NR44, setting
    ; the wavelen and some additional redundant bits. The two most
    ; significant bits of NR34 (length enable (6) and trigger (7)) are
    ; set by this subroutine too, immediately triggering the sound to
    ; play.

.get_len:
    inc hl                      ; our length data is offset by 1
    ld a, [hl]                  ; grab data from pointer
    
    ld c, a                     ; copy the length data to c
    ld a, b                     ; copy offset to a for jump table
    
    push af                     ; copy jump table offset for later
    push hl                     ; push pointer again for later
    
    call JUMP_TABLE
    dw .set_len_ch1, .set_len_ch2, .set_len_ch3, .set_len_ch4

    ; each of the below table entries sets the correct
    ; channel length register to the contents of c

.set_len_ch1:
    ld hl, SOUND_CH1_LEN_DUTY
    ld [hl], c

    jr .get_wavelen

.set_len_ch2:
    ld hl, SOUND_CH2_LEN_DUTY
    ld [hl], c

    jr .get_wavelen

.set_len_ch3:
    ld hl, SOUND_CH3_LEN
    ld [hl], c

    jr .get_wavelen

.set_len_ch4:
    ld hl, SOUND_CH4_LEN
    ld [hl], c

    jr .get_wavelen

.get_wavelen:
    ; expects hl to point towards the length data
    pop hl                      ; grab saved pointer from earlier
    inc hl
    ld c, [hl]                  ; copy wavelen_l to c
    inc hl
    ld a, [hl]                  ; copy wavelen_h to a
    or $C0                      ; this sets the two msb (see above)
    ld b, a                     ; now copy wavelen_h + flags to b
    ; bc now holds our wavelen data with the correct flags set

    pop af                      ; retrieve stored jump table offset
    call JUMP_TABLE
    dw .set_wavelen_ch1, .set_wavelen_ch2, .set_wavelen_ch3, .set_wavelen_ch4

    ; all of the below are pretty straightforward:
    ; we simply copy the contents of de to the correct registers per channel

.set_wavelen_ch1:
    ld hl, SOUND_CH1_WAVELEN_L
    ld [hl], c

    ld hl, SOUND_CH1_WAVELEN_H_CTRL
    ld [hl], b

    jr .exit

.set_wavelen_ch2:
    ld hl, SOUND_CH2_WAVELEN_L
    ld [hl], c

    ld hl, SOUND_CH2_WAVELEN_H_CTRL
    ld [hl], b

    jr .exit

.set_wavelen_ch3:
    ld hl, SOUND_CH3_WAVELEN_L
    ld [hl], c

    ld hl, SOUND_CH3_WAVELEN_H_CTRL
    ld [hl], b

    jr .exit

.set_wavelen_ch4:
    ld hl, SOUND_CH4_FREQ_RAND
    ld [hl], c

    ld hl, SOUND_CH4_CTRL
    ld [hl], b

    jr .exit

.exit:
    ; perform any cleanup here if necessary

    ; ...currently it's not necessary
    ret
