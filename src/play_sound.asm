INCLUDE "play_sound.inc"

SECTION "PLAY_SOUND", ROM0
PROCESS_SOUND_OBJ::
    ; Process a single sound object from our data.
    ;
    ; We take a pointer to our sound data in hl and which channel the data
    ; is intended for in a, and use the data structure found there to perform
    ; some sound operation. For full details of the sound feature set, see
    ; the description in demo_music.asm.

    ; TODO: process the channel at the start and push the sound registers we're
    ; working with to the stack at the start. Also allows us to check if the
    ; channel is still playing quickly and break if so.

    ; FIXME
    ; There's a bit of a conundrum here...
    ; We can either process the channel at the start, which means we have to
    ; push all the registers we'll need later onto the stack and then pop them
    ; off later. Or, we can `push af` and then jump around later on. This
    ; requres more jump tables but also doesn't require as much stack fuckery.
    ;

    ; FIXME (again)
    ; maybe the best course of action here is to just pass in a, as we always
    ; have that pointer in RAM anyway
    ;
    ; what we can do is just use a to jump around per register and by keeping
    ; a copy of it, we can decide which pointer to work with when either
    ; looking at our structs or when setting the next pointer

    call JUMP_TABLE
    dw .cfg_ch1, .cfg_ch2, .cfg_ch3, .cfg_ch4

.cfg_ch1:
    ld bc, CH1_PTR
    push bc
    ld bc, CH3_WAVELEN_H_CTRL
    push bc
    ld bc, CH3_WAVELEN_L
    push bc
    ld bc, CH3_LEN
    push bc
.cfg_ch2:
    ld bc, CH2_PTR
    push bc
    ld bc, CH3_WAVELEN_H_CTRL
    push bc
    ld bc, CH3_WAVELEN_L
    push bc
    ld bc, CH3_LEN
    push bc
.cfg_ch3:
    ld bc, CH3_PTR
    push bc
    ld bc, CH3_WAVELEN_H_CTRL
    push bc
    ld bc, CH3_WAVELEN_L
    push bc
    ld bc, CH3_LEN
    push bc
.cfg_ch4:
    ld bc, CH4_PTR
    push bc
    ld bc, CH3_WAVELEN_H_CTRL
    push bc
    ld bc, CH3_WAVELEN_L
    push bc
    ld bc, CH3_LEN
    push bc

.read_cmd
    push hl ; keep a copy of the address we're looking at

    ld a, [hl] ; load in our current command

    ; == JUMP TABLE ==
    ; We want to go the location corresponding to our opcode
    ; We need to multiply our offset by 3 to match size to the instructions
    call JUMP_TABLE
    dw .cmd_noop, .cmd_play, .cmd_goto

.cmd_noop:
    ; FIXME: NEEDS TO PLAY NO SOUND
    jp .cleanup
    
.cmd_play:
    pop hl ; grab our address back off the stack

    ; length data is stored at an offset of 1
    inc hl

    ; store length in b
    ld a, [hli]
    ld b, a

    ; store wavelen in bc
    ld a, [hli]
    ld b, a
    ld a, [hli]
    ld c, a

    ; grab length from b and store in a for function call
    ld a, b

    call PLAY_SOUND

    ret
    
.cmd_goto:
    pop hl ; grab our address back off the stack
    inc hl
    jp .cleanup

.cleanup:
    ; flush out stack
    pop hl
    pop hl
    pop hl

    ret

PLAY_SOUND::
    ; takes pointer to sound data in hl and plays the corresponding sound
    ; according to the channel select in a
    ;
    ; arguments:
    ; > registers
    ;   * a   (u8) - sound length data
    ;   * bc (r16) - wavelen data
    ; > stack
    ;   * sp + 3 (r16) - length
    ;   * sp + 2 (r16) - wavelen lower 8b
    ;   * sp + 1 (r16) - wavelen upper 3b & control
    ;
    ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ;
    ; we have a bunch of structures in our sound ROM that look like:
    ;
    ; {
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

    pop de                      ; keep a copy of the return address

    pop hl                      ; grab length register from stack
    ld [hl], a

    pop hl                      ; grab wavelen_l register from stack
    ld [hl], c

    pop hl                      ; grab wavelen_l register from stack
    ld a, b
    or $C0                      ; this sets the two msb (see above)
    ld [hl], a

    pop hl                      ; take the current ptr address off the stack
    ld [hl], 

    push de                     ; pop our return addr back on the stack

    ret
